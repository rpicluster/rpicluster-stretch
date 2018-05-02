import sys
sys.stdout.write("\r[%s%s] %s %s" % (("|||||"*int(sys.argv[1])), ("     "*int(sys.argv[2])), sys.argv[3], sys.argv[4]))
sys.stdout.flush()
