CKEDITOR.editorConfig = function( config ) {
  // Define changes to default configuration here.
  // For the complete reference:
  // http://docs.ckeditor.com/#!/api/CKEDITOR.config

  // The toolbar groups arrangement, optimized for two toolbar rows.
  config.toolbarGroups = [
  { name: 'basicstyles', groups: [ 'basicstyles' ] },
  { name: 'styles' , groups: [ 'Format' ] },
  { name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },


  ];

  config.format_tags = 'p;h3';

  // Remove some buttons, provided by the standard plugins, which we don't
  // need to have in the Standard(s) toolbar.
  config.removeButtons = 'Strike,Underline,Subscript,Superscript,Cut,Copy,Paste,Undo,Redo,Font,Blockquote,FontSize,Styles';

  // Language
  config.language = 'en';
  config.height = '300px';

  // Remove html statusbar
  removePlugins: 'elementspath'

};

(function() {
  var isChrome = /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor);
  if (isChrome) {
    CKEDITOR.on( 'instanceLoaded', function( e ){
      this.addCss('.cke_editable { line-height: normal; }');
    });
  }
})();
