require 'ftools'

Redwood::reporting_thread("dump") do
    maintain = 7
    wait = 21600
    sleep 10 # give sup time to start so we talk to the user instead of the log
    while true
        say "Rotating dumps"
        filename = File.join(BASE_DIR, "dump")
        maintain.downto(0) do |i|
            rotatename = filename + "." + i.to_s
            if File.exist?(rotatename)
                if i == maintain
                    File.unlink(rotatename)
                else
                    File.move(rotatename, filename + "." + (i+1).to_s)
                end
            end
        end
        say "Dumping labels to .sup/dump.0"
        dumpfile = File.new(filename + ".0", "w")
        Redwood::Index.each_message :load_spam => true, :load_deleted => true, :load_killed => true do |m|
            dumpfile.puts "#{m.id} (#{m.labels.to_a.sort_by { |l| l.to_s } * ' '})"
        end
        dumpfile.close
        say "Done dumping"
        sleep 5 # keep it on the screen for a few seconds before clearing it
        BufferManager.clear @__say_id if @__say_id
        sleep wait
    end
end
