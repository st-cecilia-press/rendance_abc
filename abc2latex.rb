#!ruby

ARTICLES = ['The','La','Le','Il','Lo','de la','de','des','sont des']
DANCETYPES = ['Ballo del','Galliard','Pavane','Bransle']

def flush_buffer(lines,tune_num)
  m = nil
  lines.find { |line| m = line.match(/^T:(.*)/) }
  
  STDERR.puts(m[1])
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

def move_article(dance)
  if m = dance.match(%r(^(#{ARTICLES.join('|')}) (.*)))
    "#{m[2][0].upcase}#{m[2][1..-1]}, #{m[1].downcase}"
  else
    dance
  end
end

def move_article_for_dancetype(dance)
  if m = dance.match(%r(^(#{ARTICLES.join('|')}) (.*)))
    "#{m[2][0].upcase}#{m[2][1..-1]} #{m[1].downcase}"
  else
    dance
  end
end

def index_entries(title)
  dances = []

  if m = title.match(%r((.*), or (.*)))
    dances = [m[1],m[2]]
  else
    dances = [title]
  end

  entries = []
  dances.each do |dance|
    if m = dance.match(%r(^(#{DANCETYPES.join('|')}):? ?(.*)))
      entries << "#{m[1]}!#{move_article(m[2])}"
      entries << move_article_for_dancetype("#{m[2]}, #{m[1]}")
    else
      entries << move_article(dance)
    end
  end

  entries.map { |e| "\\index{#{e}}" }.join("\n")
end

$bookname = ARGV[0]

handle_stdin
