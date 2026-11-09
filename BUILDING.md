# Building gibb.tech

Use Hugo **0.169.0** and Go **1.23.4 or later** (for Hugo Modules).
Beautiful Hugo is pinned to **v5.2.0** in `go.mod` and verified by `go.sum`.
Hugo downloads the theme automatically; no theme clone is needed.

```sh
git clone https://github.com/spencergibb/spencergibb.github.io.git
cd spencergibb.github.io
hugo mod download
hugo --minify
```

The generated site is in `public/`. Preview locally with `sh serve.sh`.

The presentation archive includes trusted HTML source pages, so
`security.allowContent` permits HTML while retaining the default Org exclusion.
The archive's bundled Reveal.js assets are retained for its existing slides.

To update the theme, run `hugo mod get -u`, followed by `hugo mod tidy`
and a production build. Commit both `go.mod` and `go.sum`.

Netlify builds use the Hugo version and build command in `netlify.toml`.
For the legacy GitHub Pages deployment, `deploy.sh` expects `public/` to be
a separate checkout of the published branch; it commits and pushes that checkout.
