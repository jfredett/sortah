require 'yaml'
require 'sortah'

class Contact 
  def want?(email)
    @emails.include?(email.sender) ||
    email.from.any? { |me| is?(me) }
  end
  
  def build_destination(prefix)
    local_dest = @destination #this gets around a weirdness -- the ivar doesn't end up in the right scope 
                              #otherwise
    sortah { destination local_dest, "#{prefix}/#{local_dest}/new/" }
  end

  def is?(contact)
    case contact
    when Contact
      @emails.any? { |e| contact.is? e }
    when String
      @emails.include? contact
    else 
      raise "Tried to compare a contact to something that wasn't an email address or contact object"
    end
  end

  def <<(email)
    @emails << email
    update_in_contacts
  end

  attr_reader :destination

  def initialize(emails, destination, path = '~/.sortah/contacts.yml')
    @emails = emails
    @destination = destination
    @path = path
    register_with_contacts
  end

  def register_with_contacts
    Contacts(@path).add_contact(self)
  end

  def update_in_contacts
    Contacts(@path).update(self)
  end
end

class Contacts
  def build_destinations(prefix)
    @contacts.map { |c| c.build_destination(prefix) } 
  end

  def destination_for(email)
    find(email).first.destination
  end

  def want?(email)
    @contacts.any? { |c| c.want? email } 
  end

  def find(email)
    @contacts.select { |c| c.want? email } 
  end

  def add_contact(c)
    @contacts << c
  end

  def update(c)
    @contacts = @contacts.delete_if { |k| k.is? c } #compares by email
    add_contact(c)
  end

  def save
    File.open(@path, 'w') { |f| f << @contacts.to_yaml } 
  end

  private

  def load_contacts
    @contacts = []
    @contacts = YAML.load(File.read(@path)) if File.exists?(@path)
  end

  def initialize(path = nil)
    if path
      @path = File.expand_path(path)
    else
      @path = "#{ENV["HOME"]}/.sortah/contacts.yml"
    end
    load_contacts
  end
end

def Contacts(path = nil)
  Contacts.new(path)
end
