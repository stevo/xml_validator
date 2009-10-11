require 'libxml'

module XmlValidator

  # this method validate if given xml file (xml_filename) is valid to XSD schema
  # parma xsd can be file including correct XSD schema or a string
  # for example:
  # XmlValidator.validate("C:\my_file.xml", "C:\my_file.xsd")
  # XmlValidator.validate("C:\my_file.xml", string_schema) where string_schema is a string including correct XSD schema
  def self.validate_file(xml_filename, xsd)
    begin
      messages = []
      document = LibXML::XML::Document.file(xml_filename)
      schema = File.exist?("#{xsd}") ? LibXML::XML::Schema.new(xsd) : XML::Schema.from_string(xsd)
      result = document.validate_schema(schema) do |message|
        messages << message
      end
    rescue Exception => e
      messages << "General Error: #{e.message}"
    end
    [result || false, messages.to_sentence]
  end

  def self.validate_string(xml_string, xsd)
    begin
      messages = []
      document = LibXML::XML::Document.string(xml_string)
      schema = File.exist?("#{xsd}") ? LibXML::XML::Schema.new(xsd) : XML::Schema.from_string(xsd)
      result = document.validate_schema(schema) do |message|
        messages << message
      end
    rescue Exception => e
      messages << "General Error: #{e.message}"
    end
    [result || false, messages.to_sentence]
  end

end