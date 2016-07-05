'use strict';

module.exports = function(grunt) {

    require('load-grunt-tasks')(grunt);

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        app: 'app',
        dist: 'dist',

        svgstore: {
            options: {
                prefix: 'icon-',
                svg: {
                    style: 'display:none;'
                },
            },
            default: {
                files: {
                    "<%= app %>/views/shared/_svg_defs.html": ["<%= app %>/assets/images/svg/*.svg"]
                }
            }
        },


        watch: {
            svg: {
                files: '<%= app %>/assets/images/svg/*.svg',
                tasks: ['svgstore']
            }
        }
    });


    grunt.registerTask('default', [
        'svgstore',
        'watch'
    ]);
};