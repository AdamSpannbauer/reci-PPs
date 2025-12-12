#!/usr/bin/env bash

set -e

# ------------------------------------------------------
# Config
# ------------------------------------------------------
# Inputs
MD_DIR="reci-PPs-md"
BLANK_TEMPLATE="reci-PP-template.md"

# Outputs
SEPARATE_PDF_OUT_DIR="reci-PPdfs"
COMBINED_OUT_PDF="reci-PPs-all.pdf"
OUT_TEMPLATE_PDF="reci-PP-template.pdf"
# ------------------------------------------------------


# ------------------------------------------------------
# Convert all md files into separate PDFs (via styled HTML)
# ------------------------------------------------------
mkdir -p "$SEPARATE_PDF_OUT_DIR"

for f in "$MD_DIR"/*.md; do
  base=$(basename "$f" .md)
  html_out="$SEPARATE_PDF_OUT_DIR/$base.html"
  pdf_out="$SEPARATE_PDF_OUT_DIR/$base.pdf"

  pandoc \
    "$f" \
    -s \
    -o "$html_out"

  weasyprint "$html_out" "$pdf_out"
done

echo "All reci-PP mds have been converted to PDFs separately in the '$SEPARATE_PDF_OUT_DIR' directory."
# ------------------------------------------------------


# ------------------------------------------------------
# Combine all separate PDFs into a single PDF
# ------------------------------------------------------
pdfunite "$SEPARATE_PDF_OUT_DIR"/*.pdf "$COMBINED_OUT_PDF"

echo "Combined all recipe PDFs into '$COMBINED_OUT_PDF'."
# ------------------------------------------------------


# ------------------------------------------------------
# Convert the blank template markdown to PDF (via styled HTML)
# ------------------------------------------------------
TEMPLATE_HTML="reci-PP-template.html"

pandoc \
  "$BLANK_TEMPLATE" \
  -s \
  -o "$TEMPLATE_HTML"

weasyprint "$TEMPLATE_HTML" "$OUT_TEMPLATE_PDF"

echo "The blank reci-PP template has been converted to PDF: '$OUT_TEMPLATE_PDF'."
# ------------------------------------------------------


# ------------------------------------------------------
# Cleanup intermediate HTML files
# ------------------------------------------------------
[ -d "$SEPARATE_PDF_OUT_DIR" ] && rm -f "$SEPARATE_PDF_OUT_DIR"/*.html
rm -f reci-PP-template.html
# ------------------------------------------------------