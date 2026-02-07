import vim


# Math Mode
def math():
    return vim.eval("vimtex#syntax#in_mathzone()") == "1"


def math_strict(snip):
    """
    True only if the entire trigger is inside math.
    Safe for cmp-nvim-ultisnips (where snip.matched may not exist).
    """

    # If cursor not in math → reject
    if not math():
        return False

    # During completion, UltiSnips doesn't know the match yet.
    # In that case, fall back to normal math check.
    if not hasattr(snip, "matched") or snip.matched is None:
        return True

    line, col = vim.current.window.cursor
    start_col = col - len(snip.matched)

    # Save cursor position
    curpos = vim.eval("getpos('.')")

    # Move to start of match (Vim is 1-indexed)
    vim.eval(f"setpos('.', [0, {line}, {start_col + 1}, 0])")

    start_in_math = math()

    # Restore cursor
    vim.eval(f"setpos('.', {curpos})")

    return start_in_math


# Pure Math Mode
def pureMath():
    return math() and notChem() and notUnit()


# Inline Math Mode
def inlineMath():
    return vim.eval("vimtex#syntax#in('texMathZoneTI')") == "1"


# Display Math Mode
def displayMath():
    return vim.eval("vimtex#syntax#in('texMathZoneX')") == "0" and math()


# Chemistry Mode
def chem():
    return (
        vim.eval(
            "get(vimtex#cmd#get_current(), 'name')",
        )
        == "\\ce"
        and math()
    )


# Not Chemistry Mode
def notChem():
    return not chem()


# Unit Mode
def unit():
    return (
        vim.eval(
            "get(vimtex#cmd#get_current(), 'name')",
        )
        == "\\pu"
        and math()
    )


# Not Unit Mode
def notUnit():
    return not unit()


# Text Mode
def text():
    return vim.eval("vimtex#syntax#in_mathzone()") == "0"


# Comment Mode
def comment():
    return vim.eval("vimtex#syntax#in_comment()") == "1"


# Specific Environment
def env(name):
    [x, y] = vim.eval("vimtex#env#is_inside('" + name + "')")
    return x != "0" and y != "0"
