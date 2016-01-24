#!/bin/bash
TMPFILE="$(mktemp)"
for f in "$(dirname "$0")/"*".txt"; do
	cat "$f" | tr -d '\n' > "$TMPFILE"
	mv "$TMPFILE" "$f"
done
rm "$TMPFILE"

