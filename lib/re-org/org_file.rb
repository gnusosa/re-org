module ReOrg
  class OrgFile

    attr_accessor :options

    TODO_ORGS_DIR = 'todo'
    DONE_ORGS_DIR = 'done'

    def initialize(opts={})
      @options = opts
      @options[:title]         ||= 'Untitled'
      @options[:time]            = Time.now
      @options[:date]            = Time.at(@options[:time]).strftime("%Y-%m-%d")
      @options[:org_format_date] = org_format_date(@options[:time])
      @options[:todo_dir]      ||= OrgFile.todo_dir
      @options[:notebook]      ||= File.basename(File.expand_path('.'))
      @options[:filename]        = resolve_filename
      @options[:file]            = File.expand_path(File.join(@options[:todo_dir], "#{@options[:filename]}.org"))
    end

    def []=(key, value)
      @options[key] = value
    end

    def [](key)
      @options[key]
    end

    def org_format_date(time=nil)
      time ||= @options[:time]
      Time.at(time).strftime("[%Y-%m-%d %a]")
    end

    def resolve_filename
      slug = slugify(@options[:notebook] || @options[:title])
      Time.at(@options[:time]).strftime("#{slug}-%s")
    end

    def slugify(name)
      return nil unless name
      name.gsub(/[\s.\/\\]/, '-').downcase
    end

    def self.prepare_directories(org={})
      todo_dir = org[:path] || OrgFile.todo_dir
      if not File.exists?(todo_dir)
        puts "Creating working dir at `#{todo_dir}'".green
        FileUtils.mkdir(todo_dir)
      end
    end

    def self.path
      File.expand_path(ENV['ORG_NOTEBOOKS_PATH'] || '.')
    end

    def self.todo_dir
      File.expand_path("#{self.path}/#{TODO_ORGS_DIR}", File.dirname('.'))
    end
  end
end
