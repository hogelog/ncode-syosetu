require "ncode-syosetu-core"
require "sanitize"

NcodeSyosetu::Model::Episode.class_eval do
  def body_ssml
    Sanitize.
        fragment(body_html, elements: %w(br p div)).
        gsub(%r(<br\s*/?>), "<break/>").
        gsub(%r(<(?:p|div)[^>]*>), '<p>').
        gsub(%r(</(?:p|div)>), '</p>')
  end

  def ssml
    <<-XML
<?xml version="1.0"?>
<speak version="1.1" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="ja">
#{body_ssml}
</speak>
    XML
  end
end
