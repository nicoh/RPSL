import rospy
import roslaunch
from std_msgs.msg import String

class Adaptation:
	def __init__():
		self.launch  = roslaunch.scriptapi.ROSLaunch()
		self.launch.start()
		self.package = rospy.get_param("/adaptation_package")
		self.current_proc = None

	def start_node(package_name, node_name):
		node = roslaunch.core.Node(package_name, node_name)
		self.current_proc = self.launch.launch(node_name)

	def stop_node(package_name, node_name):
		if current_proc.is_alive() == True:
			current_proc.stop()	

def adaptation_msg_callback(data):
	rospy.loginfo(rospy.get_caller_id() + "I heard %s", data.data)


def init_adaptation_node():
	rospy.init_node('adaptation_node', anonymous=True)

	rospy.Subscriber("adaptation", String, adaptation_msg_callback)
	rospy.spin()


if __name__ == '__main__':
	init_adaptation_node()	
