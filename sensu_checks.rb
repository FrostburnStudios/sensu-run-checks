#!/usr/bin/env ruby

require 'json'

# http://stackoverflow.com/questions/1489183/colorized-ruby-output
class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def pink
    colorize(35)
  end
end

def usage
  puts "Usage: $0 [CHECK_NAME|FILE ARG1 ARG2...]"
  puts "Runs all checks, or specified check, and prints the output with pretty colors."
  puts "e.g. $0 check_load"
  exit 1
end

def run(args)
  warn("Using sensu's embedded ruby") if use_embedded_ruby?

  check =
    if args.empty?
      nil
    else
      args[0].strip
    end

  if !check.nil? && File.exists?(check)
    name = File.basename(check, File.extname(check))
    cmd(name, args.join(' '))
  else
    Dir.glob("/etc/sensu/conf.d/**/*.json") do |f|
      check(f, check)
    end
  end
end

def check(path, only_check=nil)
  check = JSON.load(File.read(path))
  if check.has_key?('checks')
    check['checks'].each do |name,c|
      if only_check.nil? || only_check == name
        unless c.has_key?('type') || c['type'] == 'check'
          cmd(name, c['command'])
        end
      end
    end
  else
    warn("No checks in #{path}... ignored")
  end
end

def cmd(name, check)
  info("Running #{name}...")

  cmd = "#{ruby_env} #{check}"

  info("  #{check}")
  output = `su -s /bin/bash -c "#{cmd}" sensu`.strip

  if $? != 0
    fail("  #{output}")
  else
    success("  #{output}")
  end

  info("Done")
end

def ruby_env
  if use_embedded_ruby?
    "PATH=/opt/sensu/embedded/bin:#{ENV['PATH']}:/etc/sensu/plugins:/etc/sensu/handlers
    GEM_PATH=/opt/sensu/embedded/lib/ruby/gems/2.0.0:#{ENV['GEM_PATH']}"
  else
    ""
  end
end

def use_embedded_ruby?
  embedded = false
  if File.exists?("/etc/default/sensu")
    File.readlines("/etc/default/sensu").each do |l|
      val = l.split('=')
      if val[0].strip.downcase == "embedded_ruby"
        embedded = (val[1].strip.downcase == "true")
        break
      end
    end
  end
  embedded
end

def warn(msg)
  puts msg.pink
end

def info(msg)
  puts msg.yellow
end

def fail(output)
  puts output.red
end

def success(output)
  puts output.green
end

run(ARGV)
