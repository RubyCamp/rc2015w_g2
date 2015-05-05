require 'dxruby'
require_relative '../ruby-ev3/lib/ev3'

LEFT_MOTOR = "D"
RIGHT_MOTOR = "A"
DISTANCE_MOTOR = "B"
CLAW_MOTOR = "C"
COLOR_SENSOR = "3"
DISTANCE_SENSOR = "2"
PORT = "COM3"
MOTOR_SPEED = 32
count = 5000
x = 0
y = 0 
z = 0
i = 0
j = 0
k = 1

colors = {0 => "",1 =>  "黒", 2 => "青", 3 => "緑", 4 => "黄色", 5 => "赤", 6 => "白", 7 => "茶色"}
x1, y1 = 50, 320
x2, y2 = 410, 80
color = [200,255,255]

def on_road?(brick)
  7 != brick.get_sensor(COLOR_SENSOR, 2)
end

begin
  puts "starting..."
  font = Font.new(32)
  brick = EV3::Brick.new(EV3::Connections::Bluetooth.new(PORT))
  brick.connect
  puts "connected..."
  motors = [LEFT_MOTOR, RIGHT_MOTOR]
  # モーターの回転数を初期化
  brick.reset(*motors)

    #kaitensu = 0
    first_time=Time.new
    #x_point = 50
    #y_point = 320
    #image = Image.load("images/char.png")
    #gyro = false
    #gyro_angle = 0
    #aruku = 1
    #yokoaruki = false
   #unless gyro
   #  brick.clear_all
   #  gyro = true
   #end
#yokoaruku = 0
#width = 0


Window.loop do
    break if Input.keyDown?( K_SPACE )


	#物を離す
     if brick.get_sensor(COLOR_SENSOR, 2) == 2 && j == 1
	 brick.start(32, *motors)
	 sleep 1.0
	 brick.reverse_polarity(CLAW_MOTOR)
  	 brick.step_velocity(60, 90, 0, CLAW_MOTOR)
	break
     end

    Window.draw_font(100, 370, "開始時間： #{first_time.strftime('%H時%M分%S秒')}", font)
    Window.draw_font(100, 400, "現在時間：#{Time.new.strftime('%H時%M分%S秒')}", font)
    color = colors[brick.get_sensor(COLOR_SENSOR, 2).to_i]
    Window.draw_font(100, 0, color, font)
#    Window.draw_font(200, 0, "ジャイロ：#{brick.get_sensor(GYRO_SENSOR, 0).to_i}", font)
#   kyori = (5.5*Math::PI*kaitensu/360).to_i
#   gyro_angle = brick.get_sensor(GYRO_SENSOR, 0).to_i.abs%360
    
#	if yokoaruki #true
#      width += 15
#   	if aruku < 13
#			aruku.times do |i|
#				if color == "赤"
#      			Window.draw_font(width, 80+i*20, "○", font)
#     		 	else
#         		Window.draw_font(width, 80+i*20, "×", font)
#      		end
#   		end
#      	aruku += 1
#      	#next if aruku >= 13
#   	 end
#    else 
#		j =0
#      width
#      	 if aruku < 133
# 	      	 aruku.times do |i|
#    	 	 		if color == "赤"
#       	  		 	Window.draw_font(width, 360-i*20, "○", font)
#      			else
#          			Window.draw_font(width, 360-i*20, "×", font)
#     				end	
#    			end
#    	 		aruku += 1
#    			#	next if aruku >= 13
#      	end
#	end


 if x != 4
   brick.start(MOTOR_SPEED, DISTANCE_MOTOR)
 end

 #90°回転
 if (x == 0)
	brick.run_forward(*motors)
	brick.reverse_polarity(LEFT_MOTOR)
 	brick.step_velocity(32, 170, 0, *motors)
	brick.motor_ready(*motors)
	x = 1
	brick.clear_all
 end

 #茶色の線まで前進
 if (on_road?(brick) && x == 1)
   
   #x_point = (kyori*Math.cos(gyro_angle)).to_i*4 + 50
   #y_point = 320 - (kyori*Math.sin(gyro_angle)).to_i*4
   #if x_point > 0 && y_point > 0
   #  Window.draw_font(30, 20, "座標:(x,y) = (#{x_point}, #{y_point})", font)
   #  Window.draw(x_point,y_point,image)
   #end

	brick.run_forward(*motors)
 	brick.step_velocity(32, 30, 60, *motors)
	brick.motor_ready(*motors)
	sleep 0.1
	z += brick.get_count(LEFT_MOTOR).abs
	if (on_road?(brick) == false && z >= count*k)
		if i == 0
			x = 3
			i = 1
			y += 1
		elsif i == 1
			x = 2
			i = 0
			y += 1
		end
		z = 0

	elsif (on_road?(brick) == false && z <= count*k)
		x = 1
	end

elsif (on_road?(brick)== false && x == 1)
	brick.run_forward(*motors)
 	brick.step_velocity(32, 30, 60, *motors)
	brick.motor_ready(*motors)
	sleep 0.1
	z += brick.get_count(LEFT_MOTOR).abs
	if (on_road?(brick) == false && z >= count*k)
		if i == 0
			x = 3
			i = 1
			y += 1
		elsif i == 1
			x = 2
			i = 0
			y += 1
		end
		z = 0

	elsif (on_road?(brick) == false && z <= count*k)
		x = 1
	end	

end

 #180度回転
 if (x == 2)

	brick.run_forward(*motors)
	brick.reverse_polarity(LEFT_MOTOR)
 	brick.step_velocity(32, 330, 0, *motors)
	brick.motor_ready(*motors)
		x = 1
		brick.clear_all
 end	

 if (x == 3)

	brick.run_forward(*motors)
	brick.reverse_polarity(RIGHT_MOTOR)
 	brick.step_velocity(32, 340, 0, *motors)
	brick.motor_ready(*motors)
		x = 1
		k = 1.4
		brick.clear_all
 end	

#掴む
 if (brick.get_sensor(DISTANCE_SENSOR, 0).to_i <= 20 && j == 0)	
	brick.run_forward(*motors)
	brick.start(63, *motors)
	sleep 0.1
	if brick.get_sensor(DISTANCE_SENSOR, 0).to_i <= 12

		brick.run_forward(CLAW_MOTOR)
 		brick.step_velocity(32, 90, 0, CLAW_MOTOR)
		brick.motor_ready(CLAW_MOTOR)
		brick.stop(false, *motors)	
		j = 1	
		x = 1
	end
 end


end
rescue
  p $!
# 終了処理
ensure
  puts "closing..."
  brick.stop(false, *motors)
  brick.stop(false, DISTANCE_MOTOR)
  brick.clear_all
  brick.disconnect
  puts "finished..."
end


