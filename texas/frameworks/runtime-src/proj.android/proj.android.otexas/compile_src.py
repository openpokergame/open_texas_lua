#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
NAME
    compile_src --

SYNOPSIS
    compile_src [-h] [-r] [-d]

    -h show help
    -r release mode
    -d debug mode
"""

import os
import sys
import getopt
import subprocess
import shutil
import platform
import json

compile_scripts = "compile_scripts.sh"   #编译加密lua脚本
encrypt_res = "encrypt_res.sh"   #加密图片资源
copy_dir = "cp -rf {0}/ {1}/"   #拷贝目录操作
copy_file = "cp -rf {0} {1}/"   #拷贝文件操作

#获取编译配置
def get_cfg_info():
	'''get config data'''
	config_file = open("./compile_src_cfg.json", "r")
	json_data = json.load(config_file)
	config_file.close()
	return json_data

#获取目录对应子目录
def joinDir(root, *dirs):
	for item in dirs:
		root = os.path.join(root, item)
	return root

#指定文件夹下的文件或者文件夹  添加到目标文件夹下
def eachFileAddToDir(fromDir,fileList,toDir):
	if fileList is None:
		print "copy fileList isn't exist"
	else:
		for index, item in enumerate(fileList):
			if item.strip():
				tempDir = os.path.join(fromDir, item)
				if os.path.exists(tempDir):
					if os.path.isfile(tempDir):
						os.system(copy_file.format(tempDir,toDir))
					elif os.path.isdir(tempDir):
						os.system(copy_dir.format(tempDir,toDir))

#删除目录下指定的文件或文件夹
def eachFileDealFromDir(fromDir,fileList):
	if fileList is None:
		print "del fileList isn't exist"
	else:
		for index, item in enumerate(fileList):
			if item.strip():
				tempDir = os.path.join(fromDir, item)
				if os.path.exists(tempDir):
					if os.path.isfile(tempDir):
						os.remove(tempDir)
					elif os.path.isdir(tempDir):
						shutil.rmtree(tempDir)

#目录下所有文件添加前缀
def eachFileAddPrefix(prefix,folderDir):
	if prefix is None:
		print "prefix is undefined"
	elif prefix == "":
		print "prefix is '' string"
	else:
		for item in os.listdir(folderDir):
			tempFile = os.path.join(folderDir, item)
			if os.path.exists(tempFile):
				if os.path.isfile(tempFile):
					#fname, ext = os.path.splitext(tempFile)
					#base_name = os.path.basename(fname)
					new_name = prefix + item
					os.rename(tempFile, os.path.join(folderDir, new_name))
				elif os.path.isdir(tempFile):
					eachFileAddPrefix(prefix,tempFile)

engineRoot = os.environ.get('QUICK_V3_ROOT')

projectRoot = os.path.split(os.path.realpath(__file__))[0]
runtimeRoot = os.path.split(projectRoot)[0]
runtimexRoot2 = os.path.split(runtimeRoot)[0]  #暂时没用到
frameworksRoot = os.path.split(runtimexRoot2)[0]  #暂时没用到
appRoot = os.path.split(frameworksRoot)[0]
print "projectRoot =============== %s" %(projectRoot)
print "runtimeRoot =============== %s" %(runtimeRoot)
print "appRoot =============== %s" %(appRoot)
if(platform.system() =="Windows"):
	compile_scripts = "compile_scripts.bat"
	encrypt_res = "encrypt_res.bat"
	copy_dir = 'xcopy /s /q /y "{0}\*.*" "{1}\"'
	copy_file = 'xcopy /s /q /y "{0}" "{1}\"'

if __name__ == '__main__':
	isRelease = True
	# ===== parse args =====
	try:
		opts, args = getopt.getopt(sys.argv[1:], "hrd")
	except getopt.GetoptError:
		# print help information and exit:
		print __doc__
		sys.exit(-2)
	for o, a in opts:
		if o == "-h":
			# print help information and exit:
			print __doc__
			sys.exit(0)
		if o == "-r":
			isRelease = True
		if o == "-d":
			isRelease = False
	
	print "cleanup android proj bin and assets"
	androidBinDir = joinDir(projectRoot, "bin")
	androidAssetsDir = joinDir(projectRoot, "assets")
	if os.path.exists(androidBinDir):
		shutil.rmtree(androidBinDir)
	if os.path.exists(androidAssetsDir):
		shutil.rmtree(androidAssetsDir)
	
	print "copy src and res to android proj temp dir"
	srcDir = joinDir(appRoot, "src")
	resDir = joinDir(appRoot, "res")
	resTargetDir = joinDir(androidAssetsDir,"res")#工程资源路径
	srcTempDir = joinDir(androidAssetsDir,"src_temp")#临时工程代码路径
	resTempDir = joinDir(androidAssetsDir,"res_temp")#临时工程资源路径
	shutil.copytree(srcDir, srcTempDir)
	shutil.copytree(resDir, resTempDir)
	
	config_data = get_cfg_info()
	sign = config_data["sign"]
	key = config_data["key"]
	keyres = config_data["keyres"]
	copyAssets = config_data["copyAssets"]
	copySrc = config_data["copySrc"]
	copyRes = config_data["copyRes"]
	delSrc = config_data["delSrc"]
	delRes = config_data["delRes"]
	resPrefix = config_data["APP_FILE_PREFIX"]
	
	print "deal lang's src and res to android proj temp dir"
	print "copy copyAssets********************************************"
	eachFileAddToDir(runtimeRoot,copyAssets,androidAssetsDir)
	print "copy copySrc********************************************"
	eachFileAddToDir(appRoot,copySrc,srcTempDir)
	print "copy copyRes********************************************"
	eachFileAddToDir(appRoot,copyRes,resTempDir)
	print "remove delSrc********************************************"
	eachFileDealFromDir(srcTempDir,delSrc)
	print "remove delRes********************************************"
	eachFileDealFromDir(resTempDir,delRes)
	
	print "compile_scripts ------ start"
	os.system("{0}/quick/bin/{1} -i {2} -o {3}/game.zip -e xxtea_zip -ek {4} -es {5} -b 32".format(engineRoot,compile_scripts,srcTempDir,resTempDir,key,sign)) #编译32位字节码
	#os.system("{0}/quick/bin/{1} -i {2} -o {3}/game64.zip -e xxtea_zip -ek {4} -es {5} -b 64".format(engineRoot,compile_scripts,srcTempDir,resTempDir,key,sign)) #编译64位字节码
	print "compile_scripts ------ end"
	
	if isRelease:#加密
		print "encrypt res ------ start"
		os.system("{0}/quick/bin/{1} -i {2} -o {3} -ek {4} -es {5}".format(engineRoot,encrypt_res,resTempDir,resTargetDir,keyres,sign)) #加密图片资源
		print "encrypt res ------ end"
	else:#拷贝
		shutil.move(resTempDir,resTargetDir)
	
	print "remore android proj temp dir"
	if os.path.exists(srcTempDir):
		shutil.rmtree(srcTempDir)
	if os.path.exists(resTempDir):
		shutil.rmtree(resTempDir)
	#删除64位框架
	eachFileDealFromDir(resTargetDir,["framework_precompiled64.zip"])
	#添加前缀
	eachFileAddPrefix(resPrefix,resTargetDir)

	os.system(projectRoot+"/build_native.py")#编译C++ So
	os.system("gradle build")