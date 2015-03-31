module Babelyoda
  class StringsLexer
    TOKENS = [ :multiline_comment, :singleline_comment, :string, :reserved0, :equal_sign, :semicolon ].freeze

    def lex(str)
      rgxp = /(\/\*.*\*\/)|(\s*\/\/.*\n)|((["])(?:\\?+.)*?\4)|(\s*=\s*)|(;)/
      $logger.debug ">>> Scanning file with lexer:"

      $logger.debug "#{str}"
      
      str.scan(rgxp).each do |m|
      	$logger.debug "\t\t * #{m}"

        idx = m.index { |x| x }
        yield TOKENS[idx], m[idx].strip
      end
      $logger.debug ">>> Finish scanning"
    end
  end
end
