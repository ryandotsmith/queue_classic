require 'helper'

context 'Producer' do
  setup do
    setup_db
    @session = QueueClassic::Session.new( database_url )
    @producer = @session.producer_for(' foo' )
  end

  teardown do
    teardown_db
  end

  test 'producer can add an item to the queue' do
    assert_equal 0, @producer.queue.size
    @producer.put( "a message")
    assert_equal 1, @producer.queue.size
  end

  test 'a producer produces a message in the ready state' do
    msg = @producer.put( "a message")
    assert_equal :ready, msg.state
    assert msg.ready?
  end

end
