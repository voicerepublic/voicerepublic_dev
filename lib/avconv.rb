# Avconv is a utility class which provides a bunch of class methods to
# query files via shell out.
#
class Avconv
  class << self
    def duration(path)
      cmd = "avconv -i #{path} 2>&1 | grep Duration"
      output = %x[ #{cmd} ]
      md = output.match(/\d+:\d\d:\d\d/)
      md ? md[0] : nil
    end

    def start(path)
      md = path.match(/-(\d+).flv/)
      md ? md[1] : nil
    end
  end
end
