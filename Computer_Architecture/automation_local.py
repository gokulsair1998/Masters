from shutil import copyfile
import os

def runChange(sentence,line, word, replace):
	final = sentence[line].split()
	final[word]=replace
	final = ' '.join(final)
	sentence[line] = final
	return sentence

def benchchange(sentence, line, replace):
	final = sentence[line].find('(')
	sentence[line] = sentence[line][0:final+1] + replace + sentence[line][final+5:]
	return sentence

def readFile(filename):
	with open(filename,'r') as file:
		data = file.readlines()
	return data

def writeFile(filename, data):
	with open(filename,'w') as file:
		file.writelines(data)
def run():
        os.system("/home/012/a/aa/aas200006/gem5/m5out/benchmark/458.sjeng/runGem5.sh")


benchmark = "/home/012/a/aa/aas200006/gem5/m5out/benchmark/458.sjeng/runGem5.sh"
branchfile="/home/012/a/aa/aas200006/gem5/src/cpu/pred/BranchPredictor.py"
input = "input/local"



#file1 = open(branchfile,"r+")
#file2 = open(input,"w")

l1I = [64,128]
l1D = [64,128]
l2s = [64,128,512,1024]
al1I = [1,2,4]
al1D = [1,2,4]
al2 = [1,2,4]

                                                                                   
runline = readFile(benchmark)
for a in l1D:
	for b in l1I:
		for c in l2s:
			for d in al1D:
				for e in al1I:
					for f in al2:
						runChange(runline, 4, 14, "--l1d_size="+str(a)+"kB")
						runChange(runline, 4, 15, "--l1i_size="+str(b)+"kB")
						runChange(runline, 4, 16, "--l2_size="+str(c)+"kB")
						runChange(runline, 4, 17, "--l1d_assoc="+str(d))
						runChange(runline, 4, 18, "--l1i_assoc="+str(e))
						runChange(runline, 4, 19, "--l2_assoc="+str(f))
						runChange(runline, 4, 3, "./NULL"+"_"+str(a)+"_"+str(b)+"_"+str(c)+"_"+str(d)+"_"+str(e)+"_"+str(f))
						writeFile(benchmark, runline)
						run()




