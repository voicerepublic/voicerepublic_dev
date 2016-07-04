'use strict';

module.exports = function(grunt) {

    require('load-grunt-tasks')(grunt);


    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        app: 'app',
        dist: 'dist',



        convert: {
            options: {
                explicitArray: false,
            },
            csv2json: {
                src: ['<%= app %>/data/publishers.csv'],
                dest: '<%= app %>/data/publishers.json'
            }
        },
        // pageres: {
        //     screenshot: {
        //         options: {
        //             urls: ['127.0.0.1:9000', '127.0.0.1:9000/explore.html', '127.0.0.1:9000/results.html'],
        //             sizes: ['1200x800'],
        //             dest: '<%= app %>/img/screenshots',
        //             crop: true
        //         }
        //     }
        // },
        svgstore: {
            options: {
              prefix : 'icon-',

              svg: {

                style: 'display:none;'
              },

            },
            default: {
                files: {
                    "<%= app %>/views/shared/_svg-defs2.html":["<%= app %>/assets/images/svg/*.svg"]
                }
            }
          },


        sass: {
            options: {

                includePaths: ['<%= app %>/bower_components/foundation-sites/scss']
            },
            dist: {
                options: {
                    outputStyle: 'extended'
                },
                files: {
                    '<%= app %>/css/app.css': '<%= app %>/scss/app.scss'
                }
            }
        },

        assemble: {
            pages: {
                options: {
                    flatten: true,
                    assets: '<%= app %>',
                    layout: '<%= app %>/templates/layouts/default.hbs',
                    data: '<%= app %>/data/*.{json,yml}',
                    partials: '<%= app %>/templates/partials/*.hbs',
                    plugins: ['assemble-contrib-permalinks', 'assemble-contrib-sitemap'],
                },
                files: {
                    '<%= app %>/': ['<%= app %>/templates/pages/*.hbs']
                }
            }
        },

        browserSync: {
            options: {
                notify: false,
                background: true
            },
            livereload: {
                options: {
                    files: [
                        '<%= app %>/{,*/}*.html',
                        '.tmp/styles/{,*/}*.css',
                        '<%= app %>/images/{,*/}*',
                        '.tmp/scripts/{,*/}*.js'
                    ],
                    port: 9003,
                    server: {
                        baseDir: ['.tmp', 'app'],
                        routes: {
                            '/bower_components': './bower_components'
                        }
                    }
                }
            },
            // test: {
            //   options: {
            //     port: 9001,
            //     open: false,
            //     logLevel: 'silent',
            //     host: 'localhost',
            //     server: {
            //       baseDir: ['.tmp', './test', config.app],
            //       routes: {
            //         '/bower_components': './bower_components'
            //       }
            //     }
            //   }
            // },
            dist: {
                options: {
                    background: false,
                    server: '<%= dist %>'
                }
            }
        },

        jshint: {
            options: {
                jshintrc: '.jshintrc'
            },
            all: [
                'Gruntfile.js',
                '<%= app %>/js/**/*.js'
            ]
        },

        clean: {
            dist: {
                src: ['<%= dist %>/*']
            },
        },
        copy: {
            dist: {
                files: [{
                    expand: true,
                    cwd: '<%= app %>/',
                    src: [
                        'fonts/**',
                        '**/*.html',
                        '!**/*.scss',
                        '!bower_components/**',
                        'js/sup-topbar.min.js'
                    ],
                    dest: '<%= dist %>/'
                }]
            },
        },

        imagemin: {
            target: {
                files: [{
                    expand: true,
                    cwd: '<%= app %>/img/',
                    src: ['**/*.{jpg,gif,svg,jpeg,png}'],
                    dest: '<%= dist %>/img/'
                }]
            }
        },

        uglify: {
            options: {
                preserveComments: 'some',
                mangle: false
            }
        },

        useminPrepare: {
            html: ['<%= app %>/index.html'],
            options: {
                dest: '<%= dist %>'
            }
        },

        usemin: {
            html: ['<%= dist %>/**/*.html', '!<%= app %>/bower_components/**'],
            css: ['<%= dist %>/css/**/*.css'],
            options: {
                dirs: ['<%= dist %>']
            }
        },

        watch: {
            // assemble: {
            //     files: ['<%= app %>/{data,templates}/{,*/}*.{md,hbs,yml,haml}'],
            //     tasks: ['assemble']
            // },
            // grunt: {
            //     files: ['Gruntfile.js'],
            //     tasks: ['sass']
            // },
            // sass: {
            //     files: '<%= app %>/scss/**/*.scss',
            //     tasks: ['sass', 'sync']
            // },
            // js: {
            //     files: '<%= app %>/js/*.js',
            //     tasks: ['sync:js']
            // },
            svg: {
                files: '<%= app %>/assets/images/svg/*.svg',
              tasks: ['svgstore']
            }
            // postcss: {
            //  files: '<%= app %>/scss/**/*.scss',
            //  tasks: ['postcss']
            // },
            // livereload: {
            //     files: ['<%= app %>/**/*.html', '!<%= app %>/bower_components/**', '<%= app %>/js/**/*.js', '<%= app %>/css/**/*.css', '<%= app %>/scss/**/*.scss', '<%= app %>/images/**/*.{jpg,gif,svg,jpeg,png}'],
            //     options: {
            //         livereload: true
            //     }
            // },
        },

        connect: {
            app: {
                options: {
                    port: 9003,
                    base: '<%= app %>/',
                    open: true,
                    livereload: true,
                    hostname: '127.0.0.1'
                }
            },
            dist: {
                options: {
                    port: 9001,
                    base: '<%= dist %>/',
                    open: true,
                    keepalive: true,
                    livereload: false,
                    hostname: '127.0.0.1'
                }
            }
        },

        postcss: {
            options: {
                map: true,
                processors: [
                    require('autoprefixer-core')({
                        browsers: ['last 2 versions']
                    })
                ]
            },
            dist: {
                src: '<%= app %>/css/*.css'
            }
        },

        wiredep: {
            target: {
                src: [
                    '<%= app %>/**/*.html'
                ],
                exclude: [
                    'modernizr',
                    'jquery-placeholder',
                    'foundation-sites'
                ]
            }
        },

      sync: {
        main: {
          files: [{
            cwd: 'app/css',
            src: ['*.css'],
            dest: '../voicerepublic/public/assets/stylesheets'
          }],
          verbose: true // Display log messages when copying files
        },
        js: {
          files: [{
            cwd: 'app/js',
            src: ['**/*.js'],
            dest: '../voicerepublic/public/assets/javascripts'
          }],
          verbose: true
        }
      }

    });


    grunt.registerTask('compile-sass', ['sass']);
    grunt.registerTask('bower-install', ['wiredep']);

    grunt.registerTask('default', [
       //'convert',
       'svgstore',
        //'assemble',
        //'compile-sass',

        //'sync',
        //'sync:js',
        //'postcss',

        //'bower-install',
        //'browserSync:livereload',
        //'connect:app',
        'watch'
    ]);
    grunt.registerTask('validate-js', ['jshint']);
    grunt.registerTask('server-dist', ['connect:dist']);
    grunt.registerTask('data', ['convert']);
    grunt.registerTask('publish', ['compile-sass', 'clean:dist',
        //'validate-js',
        'useminPrepare', 'copy:dist', 'concat', 'cssmin', 'uglify', 'usemin'
    ]);

};
