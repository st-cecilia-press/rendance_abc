#!ruby

def flush_buffer(lines,tune_num)
  m = nil
  lines.find { |line| m = line.match(/^T:(.*)/) }
  
  puts index_entries(m[1])
  puts <<~EOT
    \\addcontentsline{toc}{subsection}{#{m[1]}}
    \\begin{abc}[name=#{$bookname}#{tune_num}]
    #{lines.join("")}
    \\end{abc}
  EOT
#  puts <<~EOT
#    \\addcontentsline{toc}{subsection}{#{m[1]}}
#  EOT
end

def handle_stdin
  buf = []
  tune_num = 0

  STDIN.each_line do |line|
    buf << line
    if line.match(/^\s*$/)
      tune_num += 1
      flush_buffer(buf,tune_num)
      buf = []
    end
  end
end

def index_entries
  articles = ['The','La','Le','Il','Lo']
  dancetype = ['Ballo del','Galliard:',%r(Pavane:?(de)),%r(Bransle ?(de|des|sont des|de la))]

  # , or
  # ()
end

$bookname = ARGV[0]

handle_stdin
