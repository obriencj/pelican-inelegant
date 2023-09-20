import fs from "fs";
import path from "path";
import { src, dest, watch, parallel, series } from "gulp";
import { exec } from "child_process";
import { create as browserSyncCreate } from "browser-sync";
import run from "gulp-run-command";
import postcss from "gulp-postcss";
import magician from "postcss-font-magician";
import cssnano from "cssnano";
import postcssPresetEnv from "postcss-preset-env";
import rfs from "rfs";
import concat from "gulp-concat";
import terser from "gulp-terser";

const compileBootstrapLess = () =>
  exec(
    "node_modules/recess/bin/recess --compile source/bootstrap/bootstrap.less > source/css/bootstrap.css"
  );

const compileResponsiveLess = () =>
  exec(
    "node_modules/recess/bin/recess --compile source/bootstrap/responsive.less > source/css/bootstrap_responsive.css"
  );

const pathProdCSS = path.join(
  __dirname,
  "static/css/elegant.prod.9e9d5ce754.css"
);

const rmProdCSS = (cb) => {
  if (fs.existsSync(pathProdCSS)) {
    fs.unlinkSync(pathProdCSS);
  }
  cb();
};

const minifyJS = () => {
  return src([
      "source/applause-button/applause-button.js",
      "source/photoswipe/photoswipe.js",
      "source/photoswipe/photoswipe-ui-default.js",
      "source/photoswipe/photoswipe-array-from-dom.js",
      "source/lunr/lunr.js",
      "source/clipboard/clipboard.js",
      "source/js/create-instagram-gallery.js",
      "source/js/copy-to-clipboard.js",
      "source/js/lunr-search-result.js",
  ])
    .pipe(concat("elegant.prod.9e9d5ce754.js"))
    .pipe(terser())
    .pipe(dest("static/js/"));
};

const compileCSS = () => {
  const plugins = [
    // postcssPresetEnv comes with autoprefixer
    postcssPresetEnv({ stage: 1 }),
    magician({}),
    rfs(),
    cssnano({
      preset: "default",
    }),
  ];
  return src([
      "source/applause-button/applause-button.css",
      "source/photoswipe/photoswipe.css",
      "source/photoswipe/default-skin/default-skin.css",
      "source/css/*.css",
  ])
    .pipe(postcss(plugins))
    .pipe(concat("elegant.prod.9e9d5ce754.css"))
    .pipe(dest("static/css/"));
};

const buildAll = series(
  rmProdCSS,
  compileBootstrapLess,
  compileResponsiveLess,
  compileCSS,
  minifyJS,
);

exports.validate = run("jinja-ninja templates");

exports.js = minifyJS;

exports.css = series(
  rmProdCSS,
  compileBootstrapLess,
  compileResponsiveLess,
  compileCSS
);

const build = series(
  compileBootstrapLess,
  compileResponsiveLess,
  compileCSS,
  minifyJS,
);
exports.build = build;

exports.default = build;
