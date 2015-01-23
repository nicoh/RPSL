import rospy
import roslaunch
from std_msgs.msg import String

launch = roslaunch.scriptapi.ROSLaunch()
launch.start()
package_name = 'rqt_gui'
current_proc = None


class Adaptation(self):


def start_node(node_name):
	#node = roslaunch.core.Node(package_name, node_name)
	#current_proc = launch.launch(node)
	current_proc = launch.launch(roslaunch.core.Node(package_name, node_name))

def stop_node(node_name):
	if current_proc.is_alive() == True:
		current_proc.stop()	

def adaptation_stop_msg_callback(data):
	rospy.loginfo(rospy.get_caller_id() + "I heard %s", data.data)
	stop_node(data.data)

def adaptation_start_msg_callback(data):
	rospy.loginfo(rospy.get_caller_id() + "I heard %s", data.data)
	start_node(data.data)

def init_adaptation_node():
	rospy.init_node('adaptation_node', anonymous=True)

	rospy.Subscriber("adaptation_start", String, adaptation_start_msg_callback)
	rospy.Subscriber("adaptation_stop", String, adaptation_stop_msg_callback)
	rospy.spin()


if __name__ == '__main__':
	init_adaptation_node()	
