require 'libxml'

module XmlValidator

  # Tis method validates if given xml file (xml_filename) is valid against XSD schema
  # As param you can supply correct XSD schema or a string representing this secham
 
  def self.validate_abstract(xsd, &block)
    begin
      messages = []
      document = block.call
      schema = File.exist?("#{xsd}") ? ::LibXML::XML::Schema.new(xsd) : ::XML::Schema.from_string(xsd)
      result = document.validate_schema(schema) do |message|
        messages << message
      end
    rescue Exception => e
      messages << "General Error: #{e.message}"
    end
    [result || false, messages * ' ']
  end


  def self.validate_file(xml_filename, xsd)
    validate_abstract(xsd) do
      ::LibXML::XML::Document.file(xml_filename)
    end
  end

  def self.validate_string(xml_string, xsd)
    validate_abstract(xsd) do
      ::LibXML::XML::Document.string(xml_string)
    end
  end

end
