# Generate KiCad schematic PDF
Generates a PDF schematic for the provided `.kicad_sch` file

See [this list](https://github.com/stars/maartin0/lists/kicad-action-utils) for related actions

### Example
`.github/workflows/gen-sch.yml`
```yml
name: Generate PDF schematic for pull request

on:
  pull_request:
    types:
      - opened
    paths:
      - "**.kicad_sch"

jobs:
  run:
    runs-on: ubuntu-latest

    permissions:
      contents: write
      pull-requests: read

    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Checkout to latest PR commit
        env:
          PR: ${{ github.event.pull_request.url }}
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          git config --global --add safe.directory "$(pwd)"
          gh pr checkout "$(echo "$PR" | sed 's/.*\/pulls\///')"

      - name: Generate PDF schematic
        uses: maartin0/kicad-sch-action@v1
        with:
          sch: project_name.kicad_sch
          output: "schematic.pdf"

      - name: Commit and push changes
        run: |
          git config --global user.name 'github-actions'
          git config --global user.email 'github-actions[bot]@users.noreply.github.com'
          git config --global --add safe.directory "$(pwd)"
          git add schematic.pdf
          git commit -m "Generate schematic PDF"
          git push
```
