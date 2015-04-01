module Raven
	class Generator
		attr_accessor :min
		attr_accessor :max
		attr_accessor :charset
		attr_accessor :step
		attr_accessor :results

		def initialize(min, max, charset)
			@min = min
			@max = max
			@charset = charset
			@step = 0
			@results = Array.new()
		end

		def random()
			raise 'Not Implemented'
		end

		def thread(worker)
			start = (1-@generator.charset.length**(min))/(1-@generator.charset.length)
			stop = ((1-@generator.charset.length**(max+1))/(1-@generator.charset.length))-1
			work_q = Queue.new
			(start..stop).to_a.each { |x| work_q.push x }

			workers = (0...worker).map do
				Thread.new do
					begin
						while i = work_q.pop(true)
							@results.push(self.step(i))
						end
					rescue ThreadError
						p 'error'
					end
				end
			end
			workers.map(&:join)
		end

		def generate()
			first = ((1-@charset.length**(min))/(1-@charset.length))
			last = ((1-@charset.length**(max+1))/(1-@charset.length))-1
			for i in first..last
				@results.push(self.step(i))
			end
		end

		def next()
			@step += 1
			self.step(@step)
		end

		def prev()
			@step -= 1
			self.step(@step)
		end

		def step(n)
			str = ''
			index = 0
			len = @charset.length
			while n!=-1
				str[index] = @charset[0 + ((n % len == 0) ? len : n % len) - 1]
				index+=1
				n = (n-1)/len
			end
			str = str.reverse!
			str[0] = ''
			return str
		end
	end
end