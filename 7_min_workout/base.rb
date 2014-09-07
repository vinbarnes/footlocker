class Base
  EXERCISES = [ "jumping jacks", "wall sit", "push-up", "crunch", "step-up",
                "squat", "triceps dip", "plank", "high knees running", "lunge",
                "push-up and rotate", "side plank" ]
  SET_TIME_IN_SECS = 30
  REST_TIME_IN_SECS = 10

  attr_reader :exercises, :set_time, :rest_time

  def self.run(args={})
    @base = self.new(args)
    @base.run_program
  end

  def initialize(exercises: nil, set_time: nil, rest_time: nil)
    @exercises = exercises || EXERCISES
    @set_time = set_time || SET_TIME_IN_SECS
    @rest_time = rest_time || REST_TIME_IN_SECS
  end

  def next_exercise(current_exercise)
    next_index = exercises.find_index(current_exercise) + 1
    if next_index < exercises.size
      exercises[next_index]
    end
  end

  def next_exercise_message(current_exercise)
    if name = next_exercise(current_exercise)
      "(#{name})"
    end
  end

  def last_exercise?(current_exercise)
    not next_exercise(current_exercise)
  end

  def run_program
    run_for(5) { "Starting " }
    num = 1
    exercises.each do |e|
      run_for(set_time) { "Set #{num}: #{e} " }
      run_for(rest_time) { "Rest #{next_exercise_message(e)} "} unless last_exercise?(e)
      num += 1
    end
    run_for(1) { "Done" }
  end

  def run_for(time)
    msg = yield
    notify(msg)
    t = 0
    while t < time
      sleep(1)
      t += 1
      print "."
    end
    puts
  end

  def notify(msg)
    cmd = lambda { |phrase| fork { system "say '#{phrase}'" } }
    print msg
    cmd.call(msg)
  end
end
