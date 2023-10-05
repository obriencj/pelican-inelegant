
import _ from 'gulp';
const { src, dest, series } = _;

import concat from "gulp-concat";
import cssnano from "cssnano";
import magician from "postcss-font-magician";
import postcss from "gulp-postcss";
import postcssPresetEnv from "postcss-preset-env";
import rfs from "rfs";
import terser from "gulp-terser";


const minifyJS = () => {
    return src([
        "source/applause-button/applause-button.js",
        "source/js/create-instagram-gallery.js",
        "source/js/lunr-search-result.js",
        "source/lunr/lunr.js",
        "source/photoswipe/photoswipe.js",
        "source/photoswipe/photoswipe-ui-default.js",
        "source/photoswipe/photoswipe-array-from-dom.js",
    ])
        .pipe(concat("inelegant.js"))
        .pipe(terser())
        .pipe(dest("static/js/"));
};


const compileCSS = () => {
    const plugins = [
        cssnano({ preset: "default" }),
        magician({}),
        postcssPresetEnv({ stage: 1 }),
        rfs(),
    ];
    return src([
        "source/applause-button/applause-button.css",
        "source/photoswipe/photoswipe.css",
        "source/photoswipe/default-skin/default-skin.css",
        "source/css/*.css",
    ])
        .pipe(postcss(plugins))
        .pipe(concat("inelegant.css"))
        .pipe(dest("static/css/"));
};


exports.build_css = compileCSS
exports.build_js = minifyJS

exports.default = series(
    compileCSS,
    minifyJS,
);


// The end.
