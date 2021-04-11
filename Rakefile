require 'erb'
require 'rake'

Dir.glob('src/**/build.rake').each { |r| load r }

task :reflex do |t|
    template = ERB.new(File.read('.reflex.erb'))

    all_tasks = {}
    current_task = nil
    `rake -P`.each_line do |line|
        if line.start_with? "rake" then
            current_task = line[5..-1].strip
        else
            filename = line.strip
            if File.file?(filename) then
                all_tasks[current_task] = [] unless all_tasks[current_task]
                all_tasks[current_task] << filename
            end
        end
    end

    File.write('.reflex', template.result(binding))
end
