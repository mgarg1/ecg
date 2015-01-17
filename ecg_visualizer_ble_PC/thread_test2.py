# import threading
# import time
# from threading import Thread,Barrier

# var = 2 
# b = Barrier(2, timeout=50)

# def func1():
# 	time.sleep(3)
# 	b.wait()
# 	print('Working from func1')
# 	return 

# def func2():
# 	time.sleep(5)
# 	b.wait()
# 	print('Working from func2')
# 	return

# if __name__ == '__main__':
#     Thread(target = func1).start()
#     Thread(target = func2).start()

# import threading
import time
from threading import Thread#,Barrier

var = 0 
# b = Barrier(2, timeout=50)

def func1():
	time.sleep(3)
	global var
	var+=1
	while var != 2:
		pass 
	print('Working from func1')
	return 

def func2():
	time.sleep(5)
	global var
	var+=1
	while var != 2:
		pass 
	print('Working from func2')
	return

if __name__ == '__main__':
    Thread(target = func1).start()
    Thread(target = func2).start()


