class Runicode
  char_classes = %w(\p{C} \p{Z} \p{Blank})
  group = "[#{char_classes.join('')}]"
  start_of_string = "\\A#{group}+"
  end_of_string = "#{group}+\\z"
  STRIP_EXPRESSION = Regexp.new("(#{start_of_string})|(#{end_of_string})")
  # /(\A[\p{C}\p{Z}\p{Blank}]+)|([\p{C}\p{Z}\p{Blank}]+\z)/

  def self.strip(str)
    str.gsub STRIP_EXPRESSION, ''
  end

end