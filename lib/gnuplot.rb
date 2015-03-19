module Gnuplot

  private

  def gnuplot(input, output)
    commands = %Q(
      set terminal svg
      set output "#{output}"
      set nokey
      set yrange [0:]
      plot "#{input}" with lines
    )
    IO.popen("gnuplot", "w") { |io| io.puts commands }
  end

end
