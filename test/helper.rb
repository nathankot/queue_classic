$: << File.expand_path("lib")
$: << File.expand_path("test")

ENV["DATABASE_URL"] ||= "postgres:///queue_classic_test"

require "queue_classic"
require "stringio"
require "minitest/autorun"

class QCTest < Minitest::Test

  def init_db
    c = QC::Conn.new
    QC::Setup.drop(c)
    QC::Setup.create(c)
    c.execute(File.read('./test/helper.sql'))
    c.disconnect
  end

  def capture_debug_output
    original_debug = ENV['DEBUG']
    original_stdout = $stdout

    ENV['DEBUG'] = "true"
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    ENV['DEBUG'] = original_debug
    $stdout = original_stdout
  end

end
