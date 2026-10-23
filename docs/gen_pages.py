"""Pages of the documentation site generated at build time (mkdocs-gen-files).

* ``library/``: a page per class of the library, from its comment, its parameters and its ``Documentation``
  annotation, with the navigation of the packages (``library/SUMMARY.md``, read by mkdocs-literate-nav);
* ``analysis/``: the reports of ``study/analysis``, their links to the results and scripts pointing to GitHub.
"""

from __future__ import annotations

import html
import posixpath
import re
from pathlib import Path

import mkdocs_gen_files

from fastsmoothbuildings import NAME
from fastsmoothbuildings._documentation import ClassDocumentation, class_documentation, class_files

ROOT = Path(__file__).resolve().parents[1]
REPOSITORY = "https://github.com/andoludo/FastSmoothBuildings/blob/main"
MODELICA_LINK = re.compile(r'href="modelica://(?P<name>[\w.]+?)(?:#(?P<anchor>[^"]*))?"')
MARKDOWN_LINK = re.compile(r"\]\((?P<target>[^)#\s]+)(?P<anchor>#[^)\s]*)?\)")


def page(name: str, *, package: bool) -> str:
    """The file of the page of a class, relative to the docs folder."""
    parts = name.split(".")[1:]
    return "/".join(["library", *parts, "index.md"] if package else ["library", *parts[:-1], f"{parts[-1]}.md"])


def url(path: str) -> str:
    """The directory URL of a page (``use_directory_urls``)."""
    return posixpath.dirname(path) + "/" if path.endswith("index.md") else path.removesuffix(".md") + "/"


def relative(source: str, target: str) -> str:
    """The link from the page ``source`` to the page ``target`` in raw HTML, which MkDocs leaves as it is: URLs."""
    return posixpath.relpath(url(target), url(source)) + "/"


def markdown_link(source: str, target: str) -> str:
    """The link from the page ``source`` to the page ``target`` in Markdown, which MkDocs resolves: files."""
    return posixpath.relpath(target, posixpath.dirname(source))


def links(text: str, source: str, pages: dict[str, str]) -> str:
    """``text`` with its ``modelica://`` links to the pages of the classes (a class without a page: its package)."""

    def replace(match: re.Match[str]) -> str:
        name = match["name"]
        while name not in pages and "." in name:
            name = name.rsplit(".", 1)[0]
        if name not in pages:
            return match[0]
        anchor = f"#{match['anchor']}" if match["anchor"] else ""
        return f'href="{relative(source, pages[name])}{anchor}"'

    return MODELICA_LINK.sub(replace, text)


def body(info: str) -> str:
    """The HTML of a ``Documentation`` string, inside the page (without its ``<html>`` element)."""
    return re.sub(r"</?html>", "", info).strip()


def parameters_table(documentation: ClassDocumentation) -> list[str]:
    if not documentation.parameters:
        return []
    rows = ["| Parameter | Type | Unit | Default | Description |", "|---|---|---|---|---|"]
    for parameter in documentation.parameters:
        cells = (parameter.name, parameter.type, parameter.unit, parameter.default, parameter.comment)
        rows.append("| " + " | ".join(html.escape(cell).replace("|", "&#124;") for cell in cells) + " |")
    return ["## Parameters", "", *rows, ""]


def class_page(documentation: ClassDocumentation, children: list[ClassDocumentation], pages: dict[str, str]) -> str:
    source = pages[documentation.name]
    short = documentation.name.rsplit(".", 1)[-1]
    kind = f"partial {documentation.kind}" if documentation.partial else documentation.kind
    lines = [f"# {short}", "", f"*{html.escape(documentation.comment)}*" if documentation.comment else "", ""]
    file = documentation.path.relative_to(ROOT).as_posix()
    lines += [f"`{documentation.name}`, {kind} ([source]({REPOSITORY}/{file}))", ""]
    if documentation.extends:
        lines += ["Extends " + ", ".join(f"`{name}`" for name in documentation.extends) + ".", ""]
    if children:
        lines += ["| Class | Description |", "|---|---|"]
        for child in children:
            target = markdown_link(source, pages[child.name])
            lines.append(f"| [{child.name.rsplit('.', 1)[-1]}]({target}) | {html.escape(child.comment)} |")
        lines.append("")
    if documentation.info:
        lines += ['<div class="modelica-documentation" markdown="0">', links(body(documentation.info), source, pages)]
        lines += ["</div>", ""]
    lines += parameters_table(documentation)
    if documentation.revisions:
        lines += ["## Revisions", "", '<div markdown="0">', links(body(documentation.revisions), source, pages)]
        lines += ["</div>", ""]
    return "\n".join(lines)


def library_pages() -> None:
    documented = [class_documentation(path) for path in class_files()]
    pages = {item.name: page(item.name, package=item.is_package) for item in documented}
    children: dict[str, list[ClassDocumentation]] = {}
    for item in documented:
        if item.name != NAME:
            children.setdefault(item.name.rsplit(".", 1)[0], []).append(item)
    summary: list[str] = []
    for item in documented:
        with mkdocs_gen_files.open(pages[item.name], "w") as file:
            file.write(class_page(item, children.get(item.name, []), pages))
        mkdocs_gen_files.set_edit_path(pages[item.name], Path("..") / item.path.relative_to(ROOT))
        indent = "    " * item.name.count(".")
        summary.append(f"{indent}* [{item.name.rsplit('.', 1)[-1]}]({pages[item.name].removeprefix('library/')})")
    with mkdocs_gen_files.open("library/SUMMARY.md", "w") as file:
        file.write("\n".join(summary) + "\n")


def analysis_pages() -> None:
    """The reports of the analysis: links inside ``study/analysis`` stay, the others point to the repository."""
    folder = ROOT / "study" / "analysis"
    for report in sorted(folder.glob("*.md")):
        target = "analysis/index.md" if report.name == "README.md" else f"analysis/{report.name}"

        def replace(match: re.Match[str], report: Path = report) -> str:
            link = match["target"]
            if re.match(r"[a-z]+:", link) or (link.endswith(".md") and (folder / link).resolve().parent == folder):
                link = "index.md" if link == "README.md" else link
                return f"]({link}{match['anchor'] or ''})"
            resolved = (report.parent / link).resolve()
            if resolved.is_relative_to(ROOT / "docs"):  # a page of the site
                page_link = posixpath.relpath(resolved.relative_to(ROOT / "docs").as_posix(), "analysis")
                return f"]({page_link}{match['anchor'] or ''})"
            if not resolved.is_relative_to(ROOT):
                return match[0]
            kind = "tree" if resolved.is_dir() else "blob"
            location = f"{REPOSITORY.replace('/blob/', f'/{kind}/')}/{resolved.relative_to(ROOT).as_posix()}"
            return f"]({location}{match['anchor'] or ''})"

        with mkdocs_gen_files.open(target, "w") as file:
            file.write(MARKDOWN_LINK.sub(replace, report.read_text(encoding="utf-8")))
        mkdocs_gen_files.set_edit_path(target, Path("..") / report.relative_to(ROOT))


library_pages()
analysis_pages()
