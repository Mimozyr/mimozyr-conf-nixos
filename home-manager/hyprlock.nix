{ pkgs, ... }:
let
  font      = "JetBrainsMono Nerd Font Mono";
  fontSize  = 16;
  foxSize   = 18;   # размер большой лисы
  loadSize  = 18;   # размер надписи Loading
  panelSize = 20;   # размер панели с заголовком, временем и датой

  # --- палитра (hex без #) ---
  cWarm   = "ffe9b0";   # тёплая звезда
  cWhite  = "f5f5ff";   # белая звезда
  cCool   = "b8d0ff";   # холодная звезда
  cBlue   = "7aa2f7";   # основной акцент
  cCyan   = "7dcfff";   # голубой
  cPurple = "bb9af7";   # сиреневый
  cDim    = "565f89";   # приглушённый текст
  cShadow = "3b4261";   # тень блочных символов
  cRed    = "f7768e";   # ошибка
  cYellow = "e0af68";   # проверка пароля

  # --- раскладка приглашения и поля ввода ---
  promptText = "[sudo] password:";
  charW      = fontSize * 3 / 4;
  gap        = 24;
  fieldX     = 40 + (builtins.stringLength promptText) * charW + gap;

  # --- моргание ---
  blinkPeriod = 5000;   # мс между морганиями
  blinkLen    = 300;    # мс, сколько глаза закрыты

  # --- уши: одна случайная анимация на окно ---
  earWindow = 15000;    # мс: длина окна
  earStep   = 200;      # мс: длительность одного кадра (равна интервалу обновления label)

  # --- общая библиотека градиентов ---
  gradLib = pkgs.writeTextDir "grad.py" ''
    SHADOW = "${cShadow}"

    def _rgb(h):
        return [int(h[i:i + 2], 16) for i in (0, 2, 4)]

    def lerp(stops, t):
        t = max(0.0, min(1.0, t))
        n = len(stops) - 1
        if n == 0:
            return stops[0]
        pos = t * n
        i = min(int(pos), n - 1)
        f = pos - i
        a, b = _rgb(stops[i]), _rgb(stops[i + 1])
        return "%02x%02x%02x" % tuple(round(a[k] + (b[k] - a[k]) * f) for k in range(3))

    def span(text, color, extra=""):
        return '<span foreground="#%s"%s>%s</span>' % (color, extra, text)

    def render(chars):
        out, cur, buf = [], None, ""
        for ch, col in chars:
            if col != cur and buf:
                out.append(span(buf, cur))
                buf = ""
            cur = col
            buf += ch
        if buf:
            out.append(span(buf, cur))
        return "".join(out)
  '';

  # --- большая лиса: левая половина (20 колонок), "." = пустая клетка ---
  foxLeft = pkgs.writeText "fox-left.txt" ''
    ..▄▄................
    ..████..............
    ..█░░██.............
    ..█░░░██............
    ..█░░░░██...........
    ..█░░░░░██▄.........
    ..█░░░░░░░██▄.......
    .▄█░░░░░░▒▒▒██▄.....
    .█▒▒▒▒▒▒▒▒▒▒▒▒██▄...
    .█▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▄▄
    .█▒▒▒...▒▒▒▒▒▒▒▒▒▒▒▒
    █▓▓▓▓..█.▒▒▒▒▒▒▒▒▒▒▒
    ..█▓▓▓▓...▒▒▒▒▒▒▒▒▒▒
    █▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
    ...█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
    ......█▓▓▓▓▓▓▓▓▓▓▓..
    ..........█▓▓▓▓▓▓▓▓.
    ..............█▓▓▓▓▓
    .................▀▀▀
  '';

  # генерирует все кадры: глаза (open/closed) × ухо (none | L/R/B + сила 1..5)
  foxScript = pkgs.writeText "fox-frames.py" ''
    import sys, os

    src, outdir = sys.argv[1], sys.argv[2]
    base0 = [r.strip() for r in open(src, encoding="utf-8").read().splitlines() if r.strip()]
    w = max(len(r) for r in base0)
    PAD = 3   # запас слева, чтобы уху было куда отклоняться

    def shear(rows, a):
        rows = rows[:]
        for i in range(len(rows)):
            s = max(0, a - i)   # верхние строки сдвигаются сильнее
            if s:
                rows[i] = rows[i][s:] + "." * s
        return rows

    def build(eyes, ear):
        base = base0[:]
        if eyes == "closed":
            base[10] = base[10][:5] + "▒▒▒" + base[10][8:]
            base[11] = base[11][:5] + "...." + base[11][9:]
            base[12] = base[12][:7] + "▒▒▒" + base[12][10:]
        base = ["." * PAD + r.ljust(w, ".") for r in base]
        L = R = base
        if ear != "none":
            side, a = ear[0], int(ear[1:])
            if side in "LB":
                L = shear(base, a)
            if side in "RB":
                R = shear(base, a)
        out = [(l + r[::-1]).replace(".", "\u00a0") for l, r in zip(L, R)]
        return "\n".join(out) + "\n"

    ears = ["none"] + [s + str(a) for s in "LRB" for a in range(1, 6)]
    for eyes in ("open", "closed"):
        for ear in ears:
            with open(os.path.join(outdir, eyes + "-" + ear + ".txt"), "w", encoding="utf-8") as f:
                f.write(build(eyes, ear))
  '';

  foxFrames = pkgs.runCommand "fox-frames" { } ''
    mkdir -p $out
    PYTHONUTF8=1 ${pkgs.python3}/bin/python3 ${foxScript} ${foxLeft} $out
  '';

  # выбирает кадр по времени и красит его вертикальным градиентом
  foxLivePy = pkgs.writeText "fox-live.py" ''
    import sys, time, random
    from grad import lerp, span

    frames = sys.argv[1]
    BLINK_PERIOD, BLINK_LEN, WIN, STEP = (int(a) for a in sys.argv[2:6])

    FOX_STOPS = ["${cCool}", "${cBlue}", "${cPurple}"]

    # анимации ушей: (кто, сила); S = выбранное ухо, O = другое, B = оба
    ANIMS = [
        [("S", 5), ("S", 5), ("S", 2)],                                        # рывок
        [("S", 5), ("S", 1), ("S", 5), ("S", 2)],                              # двойной рывок
        [("S", 1), ("S", 2), ("S", 3), ("S", 4), ("S", 4), ("S", 3), ("S", 2), ("S", 1)],  # медленный наклон
        [("B", 4), ("B", 4), ("B", 2)],                                        # оба уха
        [("S", 5), ("S", 2), ("O", 5), ("O", 2)],                              # по очереди
        [("S", 2), ("S", 4), ("S", 2), ("S", 4), ("S", 2), ("S", 4), ("S", 1)],  # дрожь
        [("S", 3), ("S", 5), ("S", 5), ("S", 5), ("S", 3), ("S", 1)],          # широкий взмах
    ]

    ms = int(time.time() * 1000)

    # моргание
    eyes = "closed" if ms % BLINK_PERIOD < BLINK_LEN else "open"

    # уши: решение зависит только от номера окна
    win, off = divmod(ms, WIN)
    rng = random.Random(win)
    anim = rng.choice(ANIMS)
    side = rng.choice("LR")
    start = rng.randrange(0, WIN - len(anim) * STEP)

    ear = "none"
    if start <= off < start + len(anim) * STEP:
        who, a = anim[(off - start) // STEP]
        sd = {"S": side, "O": "R" if side == "L" else "L", "B": "B"}[who]
        ear = sd + str(a)

    rows = open(frames + "/" + eyes + "-" + ear + ".txt", encoding="utf-8").read().splitlines()
    n = max(1, len(rows) - 1)
    out = [span(r, lerp(FOX_STOPS, i / n)) for i, r in enumerate(rows)]
    sys.stdout.write("\n".join(out) + "\n")
  '';

  foxLive = pkgs.writeShellScript "fox-live" ''
    PYTHONUTF8=1 PYTHONPATH=${gradLib} exec ${pkgs.python3}/bin/python3 ${foxLivePy} ${foxFrames} \
      ${toString blinkPeriod} ${toString blinkLen} \
      ${toString earWindow} ${toString earStep}
  '';

  # --- надпись LOADING: горизонтальный градиент, тёплые точки ---
  loadingPy = pkgs.writeText "loading.py" ''
    import sys, time
    from grad import lerp, render, SHADOW

    WORD_STOPS = ["${cCyan}", "${cBlue}", "${cPurple}"]
    DOT_COLOR = "${cWarm}"

    # блочный шрифт 5x5: "#" = залитая клетка
    FONT = {
        "L": ["#....", "#....", "#....", "#....", "#####"],
        "O": ["#####", "#...#", "#...#", "#...#", "#####"],
        "A": ["#####", "#...#", "#####", "#...#", "#...#"],
        "D": ["####.", "#...#", "#...#", "#...#", "####."],
        "I": ["#####", "..#..", "..#..", "..#..", "#####"],
        "N": ["#...#", "##..#", "#.#.#", "#..##", "#...#"],
        "G": ["#####", "#....", "#.###", "#...#", "#####"],
    }
    WORD = "LOADING"
    H = 5

    cells = [[] for _ in range(H)]
    for ch in WORD:
        g = FONT[ch]
        for y in range(H):
            cells[y] += [c == "#" for c in g[y]] + [False]
    word_end = len(cells[0])

    # троеточие: три квадратные точки 2x2 внизу, видимых 0..3
    n = int(time.time() * 2) % 4
    for y in range(H):
        cells[y] += [False, False]
        for d in range(3):
            on = d < n and y >= 3
            cells[y] += [on, on, False]

    Wd = len(cells[0])
    out = []
    for y in range(H + 1):
        chars = []
        for x in range(Wd + 1):
            fill = y < H and x < Wd and cells[y][x]
            shadow = y > 0 and x > 0 and cells[y - 1][x - 1]
            col = lerp(WORD_STOPS, x / word_end) if x < word_end else DOT_COLOR
            if fill:
                chars.append(("█", col))
            elif shadow:
                chars.append(("░", SHADOW))
            else:
                chars.append(("\u00a0", col))
        out.append(render(chars))
    sys.stdout.write("\n".join(out) + "\n")
  '';

  loadingLive = pkgs.writeShellScript "loading-live" ''
    PYTHONUTF8=1 PYTHONPATH=${gradLib} exec ${pkgs.python3}/bin/python3 ${loadingPy}
  '';

  # --- панель: заголовок, блочное время с градиентом, дата ---
  panelPy = pkgs.writeText "panel.py" ''
    import sys, time, getpass, socket
    from grad import lerp, render, span, SHADOW

    CLOCK_STOPS = ["${cWarm}", "${cWhite}", "${cCool}", "${cBlue}", "${cPurple}"]
    DIM = "${cDim}"
    DATE_COLOR = "${cWarm}"
    SMALL = ' size="smaller"'

    # блочный шрифт 5x5: "#" = залитая клетка
    FONT = {
        "0": ["#####", "#...#", "#...#", "#...#", "#####"],
        "1": ["..#..", ".##..", "..#..", "..#..", "#####"],
        "2": ["#####", "....#", "#####", "#....", "#####"],
        "3": ["#####", "....#", "#####", "....#", "#####"],
        "4": ["#...#", "#...#", "#####", "....#", "....#"],
        "5": ["#####", "#....", "#####", "....#", "#####"],
        "6": ["#####", "#....", "#####", "#...#", "#####"],
        "7": ["#####", "....#", "....#", "....#", "....#"],
        "8": ["#####", "#...#", "#####", "#...#", "#####"],
        "9": ["#####", "#...#", "#####", "....#", "#####"],
    }
    H = 5

    digits = time.strftime("%H%M")
    colon_on = int(time.time()) % 2 == 0

    cells = [[] for _ in range(H)]
    for i, ch in enumerate(digits):
        if i == 2:
            # двоеточие: одна колонка с двумя точками, с отступами по бокам
            for y in range(H):
                cells[y] += [False, colon_on and y in (1, 3), False]
        g = FONT[ch]
        for y in range(H):
            cells[y] += [c == "#" for c in g[y]] + [False]

    Wd = len(cells[0])
    BLANK = "\u00a0"

    lines = []
    lines.append(span(getpass.getuser() + "@" + socket.gethostname() + ":~$ lock --session", DIM, SMALL))
    lines.append(BLANK)

    for y in range(H + 1):
        col = lerp(CLOCK_STOPS, y / H)
        chars = []
        for x in range(Wd + 1):
            fill = y < H and x < Wd and cells[y][x]
            shadow = y > 0 and x > 0 and cells[y - 1][x - 1]
            if fill:
                chars.append(("█", col))
            elif shadow:
                chars.append(("░", SHADOW))
            else:
                chars.append((BLANK, col))
        lines.append(render(chars))

    lines.append(BLANK)
    lines.append(span("$ date +%d.%m.%Y", DIM, SMALL))
    lines.append(span(time.strftime("%d.%m.%Y"), DATE_COLOR, SMALL))

    sys.stdout.write("\n".join(lines) + "\n")
  '';

  panelLive = pkgs.writeShellScript "panel-live" ''
    PYTHONUTF8=1 PYTHONPATH=${gradLib} exec ${pkgs.python3}/bin/python3 ${panelPy}
  '';
in
{
  home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      animations.enabled = false;

      background = [{
        monitor = "";
        color = "rgb(0a0a0a)";
      }];

      label = [
        # панель: заголовок, блочное время и дата (один label, поэтому без наложений)
        {
          monitor = "";
          text = "cmd[update:1000] ${panelLive}";
          color = "rgb(${cBlue})";
          font_family = font;
          font_size = panelSize;
          text_align = "left";
          halign = "left";
          valign = "top";
          position = "40, -40";
        }

        # приглашение перед полем ввода
        {
          monitor = "";
          text = promptText;
          color = "rgb(${cCyan})";
          font_family = font;
          font_size = fontSize;
          halign = "left";
          valign = "center";
          position = "40, 0";
        }

        # надпись LOADING с троеточием, левый нижний угол
        {
          monitor = "";
          text = "cmd[update:500] ${loadingLive}";
          color = "rgb(${cBlue})";
          font_family = font;
          font_size = loadSize;
          text_align = "left";
          halign = "left";
          valign = "bottom";
          position = "40, 40";
        }

        # большая лиса справа: моргает и двигает ушами
        {
          monitor = "";
          text = "cmd[update:200] ${foxLive}";
          color = "rgb(${cBlue})";
          font_family = font;
          font_size = foxSize;
          text_align = "left";
          halign = "right";
          valign = "center";
          position = "-80, 0";
        }
      ];

      input-field = [{
        monitor = "";
        size = "300, 30";
        position = "${toString fieldX}, 0";
        halign = "left";
        valign = "center";

        outline_thickness = 0;
        rounding = 0;
        inner_color = "rgba(00000000)";
        outer_color = "rgba(00000000)";
        font_color  = "rgb(${cWhite})";
        check_color = "rgb(${cYellow})";
        fail_color  = "rgb(${cRed})";
        font_family = font;

        fade_on_empty = false;
        placeholder_text = "";
        fail_text = "authentication failure ($ATTEMPTS)";

        dots_text_format = "*";
        dots_center = false;
        dots_size = 0.3;
        dots_spacing = 0.2;
      }];
    };
  };
}
