require "rubygems"
require "bundler/setup"
@@mtimes = {}

Bundler.require(:default)

module Rouge
    module Lexers
        class EJS < HTML
            tag 'ejs'

            state :root do
                rule /[^<&]+/m, Text
                rule /&\S*?;/, Name::Entity
                rule /<!DOCTYPE .*?>/im, Comment::Preproc
                rule /<!\[CDATA\[.*?\]\]>/m, Comment::Preproc
                rule /<!--/, Comment, :comment
                rule /<\?.*?\?>/m, Comment::Preproc # php? really?

                rule /<\s*script\s*/m do
                    token Name::Tag
                    push :script_content
                    push :tag
                end

                rule /<%(=|-)?\s*/m do
                    token Keyword
                    push :ejs
                end

                rule /<\s*style\s*/m do
                    token Name::Tag
                    push :style_content
                    push :tag
                end

                rule %r(<\s*[a-zA-Z0-9:-]+), Name::Tag, :tag # opening tags
                rule %r(<\s*/\s*[a-zA-Z0-9:-]+\s*>), Name::Tag # closing tags
            end

            state :ejs do
                rule /\s*%>/, Keyword, :pop!
                rule /.*?(?=\s*%>)/ do
                    delegate Javascript
                end
            end
        end
    end
end
