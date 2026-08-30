#!/usr/bin/env python3
import argparse
import html
from datetime import datetime, timezone
from pathlib import Path


def enclosure_url(version: str) -> str:
    return f"https://tenprintsoftware.com/downloads/walkaway/WalkAway-{version}.zip"


def rfc822(moment: datetime) -> str:
    return moment.strftime("%a, %d %b %Y %H:%M:%S +0000")


def enclosure_attrs(url: str, version: str, short: str, length: int, sig: str) -> str:
    return (
        f'url="{url}" sparkle:version="{version}" '
        f'sparkle:shortVersionString="{short}" length="{length}" '
        f'type="application/octet-stream" sparkle:edSignature="{sig}"'
    )


def item_markup(title: str, date: str, description: str, enclosure: str) -> str:
    return "\n".join(
        [
            "    <item>",
            f"      <title>{title}</title>",
            f"      <pubDate>{date}</pubDate>",
            f"      <description><![CDATA[{description}]]></description>",
            f"      <enclosure {enclosure} />",
            "    </item>",
        ]
    )


def item_xml(
    short_version: str,
    build_version: str,
    pub_date: datetime,
    description: str,
    length: int,
    signature: str,
) -> str:
    url = html.escape(enclosure_url(short_version), quote=True)
    version = html.escape(build_version, quote=True)
    short = html.escape(short_version, quote=True)
    sig = html.escape(signature, quote=True)
    title = html.escape(f"Version {short_version}", quote=False)
    return item_markup(title, rfc822(pub_date), description, enclosure_attrs(url, version, short, length, sig))


def feed_xml(item: str) -> str:
    header = '<?xml version="1.0" encoding="utf-8"?>\n'
    rss = '<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle">\n'
    return header + rss + "  <channel>\n    <title>WalkAway</title>\n" + item + "\n  </channel>\n</rss>\n"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--version", required=True)
    parser.add_argument("--build", required=True)
    parser.add_argument("--length", required=True, type=int)
    parser.add_argument("--signature", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--description", default="")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    description = args.description or f"WalkAway {args.version}"
    item = item_xml(
        args.version, args.build, datetime.now(timezone.utc), description, args.length, args.signature
    )
    Path(args.output).write_text(feed_xml(item), encoding="utf-8")


if __name__ == "__main__":
    main()
