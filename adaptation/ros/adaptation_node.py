import rospy
import roslaunch
import threading
import subprocess
import os
import time
from std_msgs.msg import String

start_node_received = False
stop_node_received = False
node_name = ""
current_proc = None

class AdaptationNode():

	def __init__(self):
		# Create the subscribers
		sub_start = rospy.Subscriber("/start_node", String, self.start_node)
		sub_stop =  rospy.Subscriber("/stop_node", String, self.stop_node)

		pub_new_conf = rospy.Publisher("/rpsl_new_conf_started", String)

		self.lock = threading.Lock()
		
		global start_node_received
		global stop_node_received
		global node_name
		global current_proc
		
		while not rospy.is_shutdown():
			self.lock.acquire()
	
			if stop_node_received == True:
				#os.system("rosnode kill aruco")			
				
				#if current_proc == None:
				#	pass

				if current_proc != None:
					current_proc.kill()	

				#if subprocess.call("rosnode kill aruco", shell=True) != 0:
				#	print "Adaptation Node: Killing != 0"
				#	pass
				#time.sleep(1)
				stop_node_received = False
				pass

			if start_node_received == True:
				#os.system(str(node_name))
				
				current_proc = subprocess.Popen(str(node_name), shell=True)
				#print current_proc.pid
				#time.sleep(1)
				#pub_new_conf.publish(std_msgs.msg.String(str(node_name)))
				start_node_received = False
				pub_new_conf.publish(str(node_name))
				pass	

			self.lock.release()	

			pass
		
	def start_node(self, name):

		self.lock.acquire()
		
		global start_node_received
		global node_name 

		node_name = name.data
		start_node_received = True

		rospy.loginfo(rospy.get_caller_id() + "I start %s", name.data)

		self.lock.release()

	def stop_node(self, name):
		
		self.lock.acquire()

		global stop_node_received
		global node_name

		node_name = name.data
		stop_node_received = True

		rospy.loginfo(rospy.get_caller_id() + "I stop %s", name.data)

		self.lock.release()

if __name__ == '__main__':
	rospy.init_node('adaptation_node', anonymous=True, disable_signals=False)

	try:
		an = AdaptationNode()
	except rospy.ROSInterruptException:
		pass
