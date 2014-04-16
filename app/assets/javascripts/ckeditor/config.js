CKEDITOR.editorConfig = function( config ) {
  // Define changes to default configuration here.
  // For the complete reference:
  // http://docs.ckeditor.com/#!/api/CKEDITOR.config

  // The toolbar groups arrangement, optimized for two toolbar rows.
  config.toolbarGroups = [
    { name: 'basicstyles', groups: [ 'basicstyles' ] },
    { name: 'styles' , groups: [ 'Format' ] },
    { name: 'links', groups : [ 'Link','Unlink' ] },
    { name: 'paragraph', groups : [ 'list', 'indent' ] },
    { name: 'document',    groups: [ 'mode' ] },
  ];

  config.format_tags = 'p;h3';

  // Remove some buttons, provided by the standard plugins, which we don't
  // need to have in the Standard(s) toolbar.
  config.removeButtons = 'Save,NewPage,Preview,Print,Strike,Underline,Subscript,Superscript,Cut,Copy,Paste,Undo,Redo,Font,Blockquote,FontSize,Styles,Anchor';

  // Language
  config.language = 'en';
  config.height = '300px';

  config.forcePasteAsPlainText = true;

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

  // config.toolbar_Full = [
  //   { name: 'document',    groups: [ 'mode', 'document', 'doctools' ], items: [ 'Source', 'Save', 'NewPage', 'DocProps', 'Preview', 'Print', 'Templates', 'document' ] },
  //   // On the basic preset, clipboard and undo is handled by keyboard.
  //   // Uncomment the following line to enable them on the toolbar as well.
  //   // { name: 'clipboard',   groups: [ 'clipboard', 'undo' ], items: [ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', 'Undo', 'Redo' ] },
  //   { name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ], items: [ 'Find', 'Replace', 'SelectAll', 'Scayt' ] },
  //   { name: 'insert', items: [ 'CreatePlaceholder', 'Image', 'Flash', 'Table', 'HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak', 'Iframe', 'InsertPre' ] },
  //   { name: 'forms', items: [ 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField' ] },
  //   '/',
  //   { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', 'RemoveFormat' ] },
  //   { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align' ], items: [ 'NumberedList', 'BulletedList', 'Outdent', 'Indent', 'Blockquote', 'CreateDiv', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', 'BidiLtr', 'BidiRtl' ] },
  //   { name: 'links', items: [ 'Link', 'Unlink', 'Anchor' ] },
  //   '/',
  //   { name: 'styles', items: [ 'Styles', 'Format', 'Font', 'FontSize' ] },
  //   { name: 'colors', items: [ 'TextColor', 'BGColor' ] },
  //   { name: 'tools', items: [ 'UIColor', 'Maximize', 'ShowBlocks' ] },
  //   { name: 'about', items: [ 'About' ] }
  // ];