fn safeCreateFile basepath = (
	-- Tries to create 'basepath'. If it's locked/undeletable (stale handle,
	-- read-only, sync-lock, etc.) it falls back to basepath_1, basepath_2, ...
	-- Returns #(filestream, actualPathUsed) or undefined if all attempts fail.
	local ext = getFilenameType basepath
	local base = substring basepath 1 (basepath.count - ext.count)
	local usedpath = basepath
	local f = undefined
	local attempt = 0
	local success = false
	while not success and attempt <= 20 do (
		try (
			f = createfile usedpath
			success = true
		) catch (
			attempt += 1
			usedpath = base + "_" + (attempt as string) + ext
		)
	)
	if not success then (
		messageBox ("Could not create file even after fallback attempts:\n" + basepath)
		undefined
	) else (
		#(f, usedpath)
	)
)

rollout AnimIV "Andrew's OAD Exporter"
(
	button Newbtn "Create OAD" width:120
	button Loadbtn "Load OAD" width:120
	label lbl1 "Anim. File:" align:#left
	label lbl2 "Total Animation:" align:#left
	listBox mAnimList selection:1 height:6
	
	
	global fname	
	local Nanims = undefined
	local Panims = undefined
	local FAnimName = undefined
	local fanpk = undefined
	local LodCheck = undefined
	local O_Name = #() 
	local N_Ofs_obj = #()
	local AnimName = #()
	local N_objAnim = #()
	local EndAn = #()
	local BonCheck = undefined
	global CharBone = undefined
	global RootO = undefined
	
	fn DelComments s cs =
	(
	local ss = trimLeft s
	local p = FindString ss cs
	if p == undefined then return ss
	else
	if p > 1 then
	return substring ss 1 (p-1)
	else return ""
	)
	
	fn Obj_pts Obj_Ch =   
( 
local Obj_pt 
  while Obj_Ch.parent != undefined do  
  (  
    Obj_pt = Obj_Ch.parent
    Obj_Ch = Obj_pt  
	--format "Obj_pt=%\n" Obj_pt.name 
  ) 
Obj_pt   
)  

fn getSubs s = (
local res = #(), i, subobj = s.children

if subobj.count>0 do 
for i = 1 to subobj.count do (
	append res subobj[i]
	if subobj[i].children.count > 0 do join res (getSubs subobj[i])
)

res
)

fn uppercase instring = ( 
local upper, lower, outstring 
  upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ" 
  lower="abcdefghijklmnopqrstuvwxyz"
  outstring=copy instring
	for i=1 to outstring.count do ( 
		j=findString lower outstring[i]
		if (j != undefined) do outstring[i]=upper[j]
	)
  outstring 
)

	on Loadbtn pressed do (									--"LOAD OAD" BUTTON
fname = GetOpenFileName caption:"Load file animation" \
                         types:"OAD-file (*.oad)|*.oad|"
if fname!=undefined then
(
f = openFile fname
if f!=undefined then
(
	thisLine = readLine f
	thisLine = readLine f
	thisLine = readLine f
	fs = filterString thisLine " "
	fs1 = filterString fs[2] "\\"
	aname= DelComments fs1[2] "."
	Nanims = #(aname)
	while not eof f do (
	local thisLine = readLine f
	if thisLine == "}" do continue
			fs = filterString thisLine " "
		N = fs[1] as integer
		fs1 = filterString fs[2] "\\"
		aname = DelComments fs1[2] "."
		appendIfUnique Nanims aname
	)
		mAnimList.items = Nanims
		      lbl1.text = "Anim. File: " + (filenameFromPath fname) 
              lbl2.text = "Total Animation: " + (Nanims.count as string) 
			folna2 = DelComments (filenameFromPath fname) "."
		      mAnimList.selection = 1
		   )
     fclose f   
	ObjE.ExpCha.Enabled = true
			CamE.ExpCam.Enabled = true
			CharE.ExpMC.enabled = true
			UVE.ExpUV.enabled = true
    gc()
   )
  )	

  
	on Newbtn pressed do (												-- "CREATE OAD" BUTTON
		fname = getSaveFileName\ 
			types:"OAD-file (*.oad)|*.oad"
		if fname != undefined then (
			lbl1.text = "Anim. File: " + (filenameFromPath fname)
			lbl2.text = "Total Animation: 0"
			Nanims = #()
			mAnimList.items = Nanims
			ObjE.ExpCha.Enabled = true
			CamE.ExpCam.Enabled = true
			CharE.ExpMC.enabled = true
			UVE.ExpUV.enabled = true
		)
	)
)

rollout CharE "Character Animation"
(
	radiobuttons TypeCExp "" labels:#("Cutscene", "In-game", "Facial anim") align:#left
		button RootB "Select root bone" width:120 align:#center tooltip:"Select root bone of character"
		edittext MCNam "Anim. Name" text:"" LabelOnTop:true align:#center width:148 height:18 offset:[0,5]
		button ExpMC "Export" width:100 align:#center tooltip:"Export Char Animation" enabled:false
	
	fn FindNameViaID fid = (
	local bonNam
	case fid of (
0: bonNam = "Char"
417: bonNam = "Char_Pelvis"
418: bonNam = "Char_L_Thigh"
419: bonNam = "Char_L_Calf"
420: bonNam = "Char_L_Foot"
421: bonNam = "Char_L_Toe0"
14512: bonNam = "L_Calf_Roll"
423: bonNam = "Char_R_Thigh"
424: bonNam = "Char_R_Calf"
425: bonNam = "Char_R_Foot"
1200: bonNam = "Char_R_Toe0"
14768: bonNam = "R_Calf_Roll"
1202: bonNam = "Char_Spine"
1203: bonNam = "Char_Spine1"
13984: bonNam = "Char_Spine2"
13985: bonNam = "Char_Spine3"
1204: bonNam = "Char_Neck"
1205: bonNam = "Char_Head"
43287: bonNam = "l_browbJnt"
43269: bonNam = "l_browaJnt"
43254: bonNam = "C_forehead"
43255: bonNam = "l_EyeJnt"
43256: bonNam = "l_uppCheekJnt"
43257: bonNam = "l_cornerLipJnt"
43258: bonNam = "l_loCheekJnt"
43259: bonNam = "l_uppLipJnt"
43260: bonNam = "l_uppLidJnt"
43267: bonNam = "l_loLidJnt"
43268: bonNam = "r_browaJnt"
43286: bonNam = "r_EyeJnt"
43270: bonNam = "r_uppLidJnt"
43271: bonNam = "r_loLidJnt"
43272: bonNam = "r_browbJnt"
43273: bonNam = "r_uppCheekJnt"
43274: bonNam = "r_uppLipJnt"
43275: bonNam = "r_cornerLipJnt"
43276: bonNam = "r_loCheekJnt"
43283: bonNam = "C_jawJnt"
43284: bonNam = "r_loLipJnt"
43285: bonNam = "l_loLipJnt"
43253: bonNam = "C_tongue_a_Jnt"
43252: bonNam = "C_tongue_b_Jnt"
14240: bonNam = "Neck_Roll"
1216: bonNam = "Char_L_Clavicle"
1217: bonNam = "Char_L_UpperArm"
1218: bonNam = "Char_L_Forearm"
1219: bonNam = "Char_L_Hand"
13776: bonNam = "Char_L_Finger0"
13777: bonNam = "Char_L_Finger01"
13778: bonNam = "Char_L_Finger02"
45156: bonNam = "Extra_01"
45157: bonNam = "Extra_02"
45158: bonNam = "Extra_03"
13779: bonNam = "Char_L_Finger1"
13780: bonNam = "Char_L_Finger11"
13781: bonNam = "Char_L_Finger12"
13782: bonNam = "Char_L_Finger2"
13783: bonNam = "Char_L_Finger21"
13784: bonNam = "Char_L_Finger22"
13785: bonNam = "Char_L_Finger3"
13792: bonNam = "Char_L_Finger31"
13793: bonNam = "Char_L_Finger32"
13794: bonNam = "Char_L_Finger4"
13795: bonNam = "Char_L_Finger41"
13796: bonNam = "Char_L_Finger42"
14497: bonNam = "Char_L_ForeTwist"
14496: bonNam = "L_UpperArmRoll"
15857: bonNam = "L_ArmRoll"
1223: bonNam = "Char_R_Clavicle"
1224: bonNam = "Char_R_UpperArm"
1225: bonNam = "Char_R_Forearm"
1232: bonNam = "Char_R_Hand"
13744: bonNam = "Char_R_Finger0"
13745: bonNam = "Char_R_Finger01"
13746: bonNam = "Char_R_Finger02"
13747: bonNam = "Char_R_Finger1"
13748: bonNam = "Char_R_Finger11"
13749: bonNam = "Char_R_Finger12"
13750: bonNam = "Char_R_Finger2"
13751: bonNam = "Char_R_Finger21"
13752: bonNam = "Char_R_Finger22"
13753: bonNam = "Char_R_Finger3"
13760: bonNam = "Char_R_Finger31"
13761: bonNam = "Char_R_Finger32"
13762: bonNam = "Char_R_Finger4"
13763: bonNam = "Char_R_Finger41"
13764: bonNam = "Char_R_Finger42"
14753: bonNam = "Char_R_ForeTwist"
14752: bonNam = "R_UpperArmRoll"
15873: bonNam = "R_ArmRoll"
			)
		bonNam
)
	
	fn DelComments s cs =
	(
	local ss = trimLeft s
	local p = FindString ss cs
	if p == undefined then return ss
	else
	if p > 1 then
	return substring ss 1 (p-1)
	else return ""
	)
	
	function selectHierarchy = (
for p in selection do
     (
     if p.children != undefined do
     (
     selectmore p.children
     )
     )
)
	
	on RootB pressed do (
	if $selection.count!=1 then messagebox "Select root bone!"
		else (
			chi=$.children
			if chi.count!=0 then (
				RootB.text = ("Selected: "+$.name)
				selectHierarchy()
				RootO=$selection as array
			) else messagebox "Object hasn't hierarchy!"
		)
)

on ExpMC pressed do (										--CHAR EXPORT
	if (animiv.lbl1.text=="Anim. File:") then (
	messageBox "Create or load OAD-file"
	) else (	
	if (MCNam.text=="") then (
	messageBox "Enter name of animation"
	) else (
	local lig = undefined
   if RootO==undefined then messagebox "No selection" else (
	  	folna = getFilenamePath fname
		folna2 = DelComments (filenameFromPath fname) "."
		opa = folna+folna2+ "\\" +MCNam.text+".onim"
		ar = (animationRange.end.frame - animationRange.start.frame) as integer
		ard = (ar as float) / framerate
		makeDir (folna+folna2) all:false
		local o = undefined, f = undefined
		try (
		o = createfile opa
		local fResult = safeCreateFile fname
		if fResult == undefined then return()
		f = fResult[1]
		if fResult[2] != fname then messageBox ("Original OAD file was locked.\nWrote animation list to a copy instead:\n" + fResult[2] + "\n\nRestart 3ds Max, then rename this file over the original when you can.")
		format "[DEBUG] TypeCExp.state=% RootO.count=% ar=%\n" TypeCExp.state RootO.count ar
		   
		if (TypeCExp.state==1) then (   				--CUTSCENE CHARACTER
				format "Version 8 2\n{\n\tFlags FLAG_0 FLAG_4 FLAG_5 FLAG_6 FLAG_7 FLAG_8\n" to: o
		format "\tFrames %\n" ar to: o
		format "\tSequenceFrameLimit %\n" ar to: o
		format "\tDuration %\n" ard to: o
		format "\t_f10 2617588364\n" to: o
		format "\tExtraFlags FLAG_1 FLAG_2\n" to:o
		format "\tSequences %\n" ar to: o
		format "\tMaterialID -1\n\tAnimation\n\t{\n\t\tBonePosition Float3 0\n\t\t{\n" to: o
			format "\t\t\tFramesData SingleChannel Static\n\t\t\t{\n\t\t\t\t0.00000355 -0.00000006 0.00000000\n\t\t\t}\n" to: o
			format "\t\t}\n" to: o
		RootOn=#()
		bonsar2=#()
		bonsar3=#()
		bonsar=#(417, 418, 419, 420, 421, 422, 423, 424, 425, 1200, 1201, 1202, 1203, 1204, 1205, 1206, 1216, 1217, 1218, 1219, 1223, 1224, 1225, 1232, 13744, 13745, 13746, 13747, 13748, 13749, 13750, 13751, 13752, 13753, 13760, 13761, 13762, 13763, 13764, 13776, 13777, 13778, 13779, 13780, 13781, 13782, 13783, 13784, 13785, 13792, 13793, 13794, 13795, 13796, 13984, 13985, 14240, 14496, 14497, 14512, 14752, 14753, 14768, 15776, 15777, 15778, 15779, 15780, 15781, 15782, 15783, 15784, 15785, 45156)
			for i=1 to RootO.count do (
				insertItem RootO[i].name RootOn (RootOn.count+1)
			)
			for i=1 to bonsar.count do (
				bonsaro=FindNameViaID bonsar[i]
				if bonsaro!=undefined then (
				bonidx=findItem RootOn bonsaro
				if bonidx != 0 then (
				bonsar2[i]=RootO[bonidx]
				) else (
				bonsar2[i]=bonsar[i]
				)
				) else (
				bonsar2[i]=bonsar[i]
				)
			)
			for i=1 to bonsar2.count do (
				bonsar3[i]=(bonsar2[i] as string) as integer
			)
			for i=1 to bonsar2.count do (
				bonsnam2=bonsar2[i]
				if bonsar3[i]!=undefined then (
					format "\t\tBoneRotation Float4 %\n\t\t{\n\t\t\tFramesData SingleChannel Static\n\t\t\t{\n\t\t\t\t0.00000000 0.00000000 0.99999990 0.00000000\n\t\t\t}\n\t\t}\n" (bonsar3[i] as string) to: o
				)
					else (
					format "\t\tBoneRotation Float4 %\n\t\t{\n\t\t\tFramesData MultiChannel\n\t\t\t{\n\t\t\t\tchannel\n\t\t\t\t{\n" (bonsar[i] as string) to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent (
						rx=at time i bonsnam2.rotation.x
						)
					) 
					else (
					rx=at time i bonsnam2.rotation.x
					)
				format "\t\t\t\t\t%\n" rx to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent (
						ry=at time i bonsnam2.rotation.y
						)
					) 
					else (
					ry=at time i bonsnam2.rotation.y
					)
				format "\t\t\t\t\t%\n" ry to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent	(
						rz=at time i bonsnam2.rotation.z
						)
					) else (
					rz=at time i bonsnam2.rotation.z
					)
				format "\t\t\t\t\t%\n" rz to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent (
						rw=at time i bonsnam2.rotation.w
						)
					) else (
					rw=at time i bonsnam2.rotation.w
					)
				format "\t\t\t\t\t%\n" rw to: o
			)
			format "\t\t\t\t}\n\t\t\t}\n\t\t}\n" to: o
			bonii=findItem bonsar bonal
			if bonii!=0 then (
			deleteItem bonsar bonii
			)
			)
		)
			bonsnam2=RootO[1]
			format "\t\tModelPosition Float3 0\n\t\t{\n" to: o
			format "\t\t\tFramesData MultiChannel\n\t\t\t{\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				rx=at time i bonsnam2.pos.x
				format "\t\t\t\t\t%\n" rx to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				ry=at time i bonsnam2.pos.y
				format "\t\t\t\t\t%\n" ry to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				rz=at time i bonsnam2.pos.z
				format "\t\t\t\t\t%\n" rz to: o
			)
			format "\t\t\t\t}\n\t\t\t}\n\t\t}\n" to: o
			format "\t\tModelRotation Float4 0\n\t\t{\n" to: o
			format "\t\t\tFramesData MultiChannel\n\t\t\t{\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
				for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent (
						rx=at time i bonsnam2.rotation.x
						)
					) 
					else (
					rx=at time i bonsnam2.rotation.x
					)
				format "\t\t\t\t\t%\n" rx to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent (
						ry=at time i bonsnam2.rotation.y
						)
					) 
					else (
					ry=at time i bonsnam2.rotation.y
					)
				format "\t\t\t\t\t%\n" ry to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent	(
						rz=at time i bonsnam2.rotation.z
						)
					) else (
					rz=at time i bonsnam2.rotation.z
					)
				format "\t\t\t\t\t%\n" rz to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent (
						rw=at time i bonsnam2.rotation.w
						)
					) else (
					rw=at time i bonsnam2.rotation.w
					)
				format "\t\t\t\t\t%\n" rw to: o
			)
			format "\t\t\t\t}\n\t\t\t}\n" to: o
			format "\t\t}\n\t}\n}\n" to: o
		)	
		else if (TypeCExp.state==2) then (			--IN-GAME CHAR
				format "Version 8 2\n{\n\tFlags FLAG_0 FLAG_4 FLAG_5 FLAG_6 FLAG_7 FLAG_8\n" to: o
		format "\tFrames %\n" ar to: o
		format "\tSequenceFrameLimit %\n" ar to: o
		format "\tDuration %\n" ard to: o
		format "\t_f10 2297553891\n" to: o
		format "\tExtraFlags FLAG_1 FLAG_2\n" to: o
		format "\tSequences %\n" ar to: o
		format "\tMaterialID -1\n\tAnimation\n\t{\n" to: o
		RootOn=#()
		bonsar2=#()
		bonsar3=#()
		bonsar=#(0, 417, 418, 419, 420, 421, 423, 424, 425, 1200, 1202, 1203, 1204, 1205, 1216, 1217, 1218, 1219, 1223, 1224, 1225, 1232, 13744, 13745, 13746, 13747, 13748, 13749, 13750, 13751, 17352, 13753, 13760, 13761, 13762, 13763, 13764, 13776, 13777, 13778, 13779, 13780, 13781, 13782, 13783, 13784, 13785, 13792, 13793, 13794, 13795, 13796, 13984, 13985)
			for i=1 to RootO.count do (
				insertItem RootO[i].name RootOn (RootOn.count+1)
			)
			for i=1 to bonsar.count do (
				bonsaro=FindNameViaID bonsar[i]
				if bonsaro!=undefined then (
				bonidx=findItem RootOn bonsaro
				if bonidx != 0 then (
				bonsar2[i]=RootO[bonidx]
				) else (
				bonsar2[i]=bonsar[i]
				)
				) else (
				bonsar2[i]=bonsar[i]
				)
			)
			for i=1 to bonsar2.count do (
				bonsar3[i]=(bonsar2[i] as string) as integer
			)
			format "\t\tBonePosition Float3 0\n\t\t{\n" to: o
			format "\t\t\tFramesData SingleChannel Static\n\t\t\t{\n\t\t\t\t0.0 0.0 0.0\n\t\t\t}\n\t\t}\n" to: o --\t\t\t\tchannel\n\t\t\t\t{\n
			for i=1 to bonsar2.count do (
				bonsnam2=bonsar2[i]
				if bonsar3[i]!=undefined then (
					format "\t\tBoneRotation Float4 %\n\t\t{\n\t\t\tFramesData SingleChannel Static\n\t\t\t{\n\t\t\t\t0.00000000 0.00000000 0.99999990 0.00000000\n\t\t\t}\n\t\t}\n" (bonsar3[i] as string) to: o
				)
					else (
					format "\t\tBoneRotation Float4 %\n\t\t{\n\t\t\tFramesData MultiChannel\n\t\t\t{\n\t\t\t\tchannel\n\t\t\t\t{\n" (bonsar[i] as string) to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent (
						rx=at time i bonsnam2.rotation.x
						)
					) 
					else (
					rx=at time i bonsnam2.rotation.x
					)
				format "\t\t\t\t\t%\n" rx to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent (
						ry=at time i bonsnam2.rotation.y
						)
					) 
					else (
					ry=at time i bonsnam2.rotation.y
					)
				format "\t\t\t\t\t%\n" ry to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent	(
						rz=at time i bonsnam2.rotation.z
						)
					) else (
					rz=at time i bonsnam2.rotation.z
					)
				format "\t\t\t\t\t%\n" rz to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent (
						rw=at time i bonsnam2.rotation.w
						)
					) else (
					rw=at time i bonsnam2.rotation.w
					)
				format "\t\t\t\t\t%\n" rw to: o
			)
			format "\t\t\t\t}\n\t\t\t}\n\t\t}\n" to: o
			bonii=findItem bonsar bonal
			if bonii!=0 then (
			deleteItem bonsar bonii
			)
			)
		)
		bonsnam2=RootO[1]
			format "\t\tModelPosition Float3 0\n\t\t{\n" to: o
			format "\t\t\tFramesData MultiChannel\n\t\t\t{\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				rx=at time i bonsnam2.pos.x
				format "\t\t\t\t\t%\n" rx to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				ry=at time i bonsnam2.pos.y
				format "\t\t\t\t\t%\n" ry to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				rz=at time i bonsnam2.pos.z
				format "\t\t\t\t\t%\n" rz to: o
			)
			format "\t\t\t\t}\n\t\t\t}\n\t\t}\n" to: o
			format "\t\tModelRotation Float4 0\n\t\t{\n" to: o
			format "\t\t\tFramesData SingleChannel Static\n\t\t\t{\n\t\t\t\t0.0 0.0 0.0 1.0\n\t\t\t}\n\t\t}\n" to: o 
			if ((T128v==undefined) or (T128v==#()) or (T128v==#("0"))) then (
				format "\t\tActionFlags UInt 0\n\t\t{\n\t\t\tFramesData SingleChannel Static\n\t\t\t{\n\t\t\t\t0\n\t\t\t}\n\t\t}\n" to: o
			)
			else (
				format "\t\tActionFlags UInt 0\n\t\t{\n\t\t\tFramesData SingleChannel\n\t\t\t{\n" to: o
				global T128v1=#()
				for i=1 to ar do (
					insertItem "0" T128v1 (T128v1.count+1)
				)
				for i=1 to T128v.count do (
					fs = filterString T128v[i] " "
					insertItem fs[2] T128v1 (fs[1] as integer)
				)
				for i=1 to ar do (
					format "\t\t\t\t%\n" (T128v1[i] as string) to: o
				)
				format "\t\t\t}\n\t\t}\n" to: o
			)
			format "\t}\n}\n" to: o
		)
		else if (TypeCExp.state==3) then (			--FACIAL ANIM
			format "Version 8 2\n{\n\tFlags FLAG_0 FLAG_6 FLAG_7 FLAG_8\n" to: o
		format "\tFrames %\n" ar to: o
		format "\tSequenceFrameLimit %\n" ar to: o
		format "\tDuration %\n" ard to: o
		format "\t_f10 2771602081\n\t_f28 0\n" to: o
		format "\tSequences %\n" ar to: o
		format "\tMaterialID -1\n\tAnimation\n\t{\n" to: o
			RootOn=#()
		bonsar2=#()
		bonsar3=#()
		facsar=#(43252, 43253, 43254, 43255, 43256, 43257, 43258, 43259, 43260, 43267, 43268, 43269, 43270, 43271, 43272, 43273, 43274, 43275, 43276, 43283, 43284, 43285, 43286, 43287)
			for i=1 to RootO.count do (
				insertItem RootO[i].name RootOn (RootOn.count+1)
			)
			for i=1 to facsar.count do (
				bonsaro=FindNameViaID facsar[i]
				if bonsaro!=undefined then (
				bonidx=findItem RootOn bonsaro
				if bonidx != 0 then (
				bonsar2[i]=RootO[bonidx]
				) else (
				bonsar2[i]=bonsar[i]
				)
				) else (
				bonsar2[i]=bonsar[i]
				)
			)
			for i=1 to bonsar2.count do (
				bonsar3[i]=(bonsar2[i] as string) as integer
			)
			for i=1 to bonsar2.count do (
				bonsnam2=bonsar2[i]
				if bonsar3[i]!=undefined then (
					format "\t\tBonePosition Float3 %\n\t\t{\n\t\t\tFramesData SingleChannel Static\n\t\t\t{\n\t\t\t\t0.00000000 0.00000000 0.99999990 0.00000000\n\t\t\t}\n\t\t}\n" (bonsar3[i] as string) to: o
				)
					else (
					format "\t\tBonePosition Float3 %\n\t\t{\n\t\t\tFramesData MultiChannel\n\t\t\t{\n\t\t\t\tchannel\n\t\t\t\t{\n" (facsar[i] as string) to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent (
						rx=at time i bonsnam2.pos.x
						)
					) 
					else (
					rx=at time i bonsnam2.pos.x
					)
				format "\t\t\t\t\t%\n" rx to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent (
						ry=at time i bonsnam2.pos.y
						)
					) 
					else (
					ry=at time i bonsnam2.pos.y
					)
				format "\t\t\t\t\t%\n" ry to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent (
						rz=at time i bonsnam2.pos.z
						)
					) 
					else (
					rz=at time i bonsnam2.pos.z
					)
				format "\t\t\t\t\t%\n" rz to: o
			)
			format "\t\t\t\t}\n\t\t\t}\n\t\t}\n" to: o
			)
			)
			for i=1 to bonsar2.count do (
				bonsnam2=bonsar2[i]
				if bonsar3[i]!=undefined then (
					format "\t\tBoneRotation Float4 %\n\t\t{\n\t\t\tFramesData SingleChannel Static\n\t\t\t{\n\t\t\t\t0.00000000 0.00000000 0.99999990 0.00000000\n\t\t\t}\n\t\t}\n" (bonsar3[i] as string) to: o
				)
				else (
				format "\t\tBoneRotation Float4 %\n\t\t{\n\t\t\tFramesData MultiChannel\n\t\t\t{\n\t\t\t\tchannel\n\t\t\t\t{\n" (facsar[i] as string) to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent (
						rx=at time i bonsnam2.rotation.x
						)
					) 
					else (
					rx=at time i bonsnam2.rotation.x
					)
				format "\t\t\t\t\t%\n" rx to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent (
						ry=at time i bonsnam2.rotation.y
						)
					) 
					else (
					ry=at time i bonsnam2.rotation.y
					)
				format "\t\t\t\t\t%\n" ry to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent	(
						rz=at time i bonsnam2.rotation.z
						)
					) else (
					rz=at time i bonsnam2.rotation.z
					)
				format "\t\t\t\t\t%\n" rz to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bonsnam2.parent!=undefined then (
					in coordsys parent (
						rw=at time i bonsnam2.rotation.w
						)
					) else (
					rw=at time i bonsnam2.rotation.w
					)
				format "\t\t\t\t\t%\n" rw to: o
			)
			format "\t\t\t\t}\n\t\t\t}\n\t\t}\n" to: o
			)
			)
			bonsnam2=RootO[1]
			format "\t\tModelPosition Float3 0\n\t\t{\n" to: o
			format "\t\t\tFramesData MultiChannel\n\t\t\t{\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				rx=at time i bonsnam2.pos.x
				format "\t\t\t\t\t%\n" rx to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				ry=at time i bonsnam2.pos.y
				format "\t\t\t\t\t%\n" ry to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				rz=at time i bonsnam2.pos.z
				format "\t\t\t\t\t%\n" rz to: o
			)
			format "\t\t\t\t}\n\t\t\t}\n" to: o
			
			format "\t\t}\n\t}\n}\n" to: o
		) else (
			messageBox ("No matching animation type branch! TypeCExp.state = " + (TypeCExp.state as string))
		)
Nanims = Animiv.mAnimList.items
		appendIfUnique Nanims MCNam.text
	format "Version 1 2\n{\n" to: f
	for i=1 to Nanims.count do (
	fly = folna2+"\\"+Nanims[i]+".onim"
	format "\tcrAnimation %\n" fly to: f
	)
	format "}\n" to: f
	AnimIV.mAnimList.items = Nanims
	animiv.lbl2.text = "Total Animation: " + (Nanims.count as string) 
		close o
		close f
		) catch (
			local errmsg = getCurrentException()
			if o != undefined do (try(close o) catch())
			if f != undefined do (try(close f) catch())
			messageBox ("Export failed:\n" + errmsg)
		)
	)
	)
	)
)
)

rollout ObjE "Object Animation"
(
	radioButtons TypeExp "" labels:#("Cutscene", "In-game") align:#left
		listBox ParList selection:1 height:3
		button ChPar "Add Bones" width:100 align:#center tooltip:"Select bones to add them to list"
		editText ChaNam "Anim. Name" text:"" LabelOnTop:true align:#center width:148 height:18 offset:[0,5]
		button ExpCha "Export" width: 100 align:#center tootip:"Export Object Animation" Enabled:false
	
	fn FindID fin = (
	local bonID
	case fin of (
        "Char": bonID = 0
        "Char_Pelvis": bonID = 417
        "Char_L_Thigh": bonID = 418
        "Char_L_Calf": bonID = 419
        "Char_L_Foot": bonID = 420
        "Char_L_Toe0": bonID = 421
        "L_Calf_Roll": bonID = 14512
        "Char_R_Thigh": bonID = 423
        "Char_R_Calf": bonID = 424
        "Char_R_Foot": bonID = 425
        "Char_R_Toe0": bonID = 1200
        "R_Calf_Roll": bonID = 14768
        "Char_Spine": bonID = 1202
        "Char_Spine1": bonID = 1203
        "Char_Spine2": bonID = 13984
        "Char_Spine3": bonID = 13985
        "Char_Neck": bonID = 1204
        "Char_Head": bonID = 1205
        "l_browbJnt": bonID = 43287
        "l_browaJnt": bonID = 43269
        "C_forehead": bonID = 43254
        "l_EyeJnt": bonID = 43255
        "l_uppCheekJnt": bonID = 43256
        "l_cornerLipJnt": bonID = 43257
        "l_loCheekJnt": bonID = 43258
        "l_uppLipJnt": bonID = 43259
        "l_uppLidJnt": bonID = 43260
        "l_loLidJnt": bonID = 43267
        "r_browaJnt": bonID = 43268
        "r_EyeJnt": bonID = 43286
        "r_uppLidJnt": bonID = 43270
        "r_loLidJnt": bonID = 43271
        "r_browbJnt": bonID = 43272
        "r_uppCheekJnt": bonID = 43273
        "r_uppLipJnt": bonID = 43274
        "r_cornerLipJnt": bonID = 43275
        "r_loCheekJnt": bonID = 43276
        "C_jawJnt": bonID = 43283
        "r_loLipJnt": bonID = 43284
        "l_loLipJnt": bonID = 43285
        "C_tongue_a_Jnt": bonID = 43253
        "C_tongue_b_Jnt": bonID = 43252
        "Neck_Roll": bonID = 14240
        "Char_L_Clavicle": bonID = 1216
        "Char_L_UpperArm": bonID = 1217
        "Char_L_Forearm": bonID = 1218
        "Char_L_Hand": bonID = 1219
        "Char_L_Finger0": bonID = 13776
        "Char_L_Finger01": bonID = 13777
        "Char_L_Finger02": bonID = 13778
        "Extra_01": bonID = 45156
        "Extra_02": bonID = 45157
        "Extra_03": bonID = 45158
        "Char_L_Finger1": bonID = 13779
        "Char_L_Finger11": bonID = 13780
        "Char_L_Finger12": bonID = 13781
        "Char_L_Finger2": bonID = 13782
        "Char_L_Finger21": bonID = 13783
        "Char_L_Finger22": bonID = 13784
        "Char_L_Finger3": bonID = 13785
        "Char_L_Finger31": bonID = 13792
        "Char_L_Finger32": bonID = 13793
        "Char_L_Finger4": bonID = 13794
        "Char_L_Finger41": bonID = 13795
        "Char_L_Finger42": bonID = 13796
        "Char_L_ForeTwist": bonID = 14497
        "L_UpperArmRoll": bonID = 14496
        "L_ArmRoll": bonID = 15857
        "Char_R_Clavicle": bonID = 1223
        "Char_R_UpperArm": bonID = 1224
        "Char_R_Forearm": bonID = 1225
        "Char_R_Hand": bonID = 1232
        "Char_R_Finger0": bonID = 13744
        "Char_R_Finger01": bonID = 13745
        "Char_R_Finger02": bonID = 13746
        "Char_R_Finger1": bonID = 13747
        "Char_R_Finger11": bonID = 13748
        "Char_R_Finger12": bonID = 13749
        "Char_R_Finger2": bonID = 13750
        "Char_R_Finger21": bonID = 13751
        "Char_R_Finger22": bonID = 13752
        "Char_R_Finger3": bonID = 13753
        "Char_R_Finger31": bonID = 13760
        "Char_R_Finger32": bonID = 13761
        "Char_R_Finger4": bonID = 13762
        "Char_R_Finger41": bonID = 13763
        "Char_R_Finger42": bonID = 13764
        "Char_R_ForeTwist": bonID = 14753
        "R_UpperArmRoll": bonID = 14752
        "R_ArmRoll": bonID = 15873
		"PropA": bonID = 0
		"PropB": bonID = 15010
		"PropC": bonID = 15011
		"PropD": bonID = 15012
		"PropE": bonID = 15013
		"PropF": bonID = 15014
		"PropG": bonID = 15015
		"PropH": bonID = 15016
		"PropI": bonID = 15017
		"PropJ": bonID = 15024
		"PropK": bonID = 15025
		"PropL": bonID = 15026
		"PropM": bonID = 15027
		"PropN": bonID = 15028
		"PropO": bonID = 15029
		"PropP": bonID = 15030
		"PropQ": bonID = 15031
		"PropR": bonID = 15032
		"PropS": bonID = 15033
		"PropT": bonID = 15040
		"PropU": bonID = 15041
		"PropV": bonID = 15042
		"PropW": bonID = 15043
		"PropX": bonID = 15044
		"PropY": bonID = 15045
		"PropZ": bonID = 15046
		"chassis": bonID = 0
		"bonnet": bonID = 15268
		"extra_1": bonID = 15335
		"extra_5": bonID = 15337
		"boot": bonID = 15269
		"bumper_f": bonID = 15266
		"extra_8": bonID = 6
		"bumper_r": bonID = 15267
		"extra_6": bonID = 15332
		"wing_lf": bonID = 15270
		"wing_rf": bonID = 15271
		"door_dside_r": bonID = 15280
		"window_lr": bonID = 15281
		"misc_a": bonID = 13
		"door_dside_f": bonID = 15272
		"window_lf": bonID = 15273
		"door_pside_r": bonID = 15284
		"window_rr": bonID = 15285
		"misc_b": bonID = 18
		"door_pside_f": bonID = 15282
		"window_rf": bonID = 15283
		"windscreen": bonID = 21
		"windscreen_r": bonID = 15287
		"hub_lf": bonID = 23
		"hub_rf": bonID = 24
		"suspension_lf": bonID = 15288
		"suspension_lr": bonID = 15289
		"suspension_rf": bonID = 15296
		"suspension_rr": bonID = 15297
		"indicator_lr": bonID = 29
		"taillight_l": bonID = 15304
		"brakelight_l": bonID = 31
		"brakelight_r": bonID = 32
		"indicator_rr": bonID = 33
		"taillight_r": bonID = 15305
		"reversinglight_l": bonID = 15316
		"reversinglight_r": bonID = 15321
		"headlight_l": bonID = 15302
		"indicator_lf": bonID = 38
		"headlight_r": bonID = 15303
		"indicator_rf": bonID = 40
		"engine": bonID = 41
		"exhaust": bonID = 42
		"seat_dside_f": bonID = 15312
		"seat_pside_f": bonID = 15313
		"seat_pside_r": bonID = 15315
		"seat_dside_r": bonID = 15314
		"exhaust_2": bonID = 47
		"interiorlight": bonID = 48
		"overheat": bonID = 49
		"overheat_2": bonID = 50
		"wheel_lf": bonID = 15298
		"wheelmesh_lf": bonID = 52
		"wheelmesh_lf_l1": bonID = 53
		"wheel_lr": bonID = 15299
		"wheel_rr": bonID = 15301
		"wheel_rf": bonID = 15300
		"extra_7": bonID = 15344
		"bodyshell": bonID = 58
		"hub_lr": bonID = 59
		"hub_rr": bonID = 60
			)
		bonID
)
	
	fn DelComments s cs =
	(
	local ss = trimLeft s
	local p = FindString ss cs
	if p == undefined then return ss
	else
	if p > 1 then
	return substring ss 1 (p-1)
	else return ""
	)
	
	on ChPar pressed do 								--"add bones" BUTTON
(
	global sc3 = #()
 local objec = #(), objec1 = #()
 local SC = selection.count
 local sc2 = selection as array
for i=1 to sc2.count do (
	sc3[i] = sc2[i]
	sc2[i] = sc2[i].name
)
parlist.items = sc2 )

on ExpCha pressed do (										--OBJ EXPORT
	if (animiv.lbl1.text=="Anim. File:") then (
	messageBox "Create or load OAD-file"
	) else (	
	if (ChaNam.text=="") then (
	messageBox "Enter name of animation"
	) else (
	local lig = undefined
   if $selection.count<1 then messagebox "No selection" else (
	   Panims = ParList.items
	   if Panims.count<1 then messagebox "Check Parent" else (
		folna = getFilenamePath fname
		folna2 = DelComments (filenameFromPath fname) "."
		opa = folna+folna2+ "\\" +ChaNam.text+".onim"
		ar = (animationRange.end.frame - animationRange.start.frame) as integer
		ard = (ar as float) / framerate
		makeDir (folna+folna2) all:false
		local o = undefined, f = undefined
		try (
		o = createfile opa
		local fResult = safeCreateFile fname
		if fResult == undefined then return()
		f = fResult[1]
		if fResult[2] != fname then messageBox ("Original OAD file was locked.\nWrote animation list to a copy instead:\n" + fResult[2] + "\n\nRestart 3ds Max, then rename this file over the original when you can.")
		if (TypeExp.state==1) then (           --CUTSCENE OBJECTS
			format "Version 8 2\n{\n\tFlags FLAG_0 FLAG_6 FLAG_7 FLAG_8\n" to: o
		format "\tFrames %\n" ar to: o
		format "\tSequenceFrameLimit %\n" ar to: o
		format "\tDuration %\n" ard to: o
		format "\t_f10 3205147457\n" to: o
		format "\tExtraFlags FLAG_1 FLAG_2\n" to: o
		format "\tSequences %\n" ar to: o
		format "\tMaterialID -1\n\tAnimation\n\t{\n" to: o
		Panims = ParList.items
		for i=1 to Panims.count do (
			bon = Panims[i]
			bon3 = sc3[i]
			bonID = getUserProp bon3 "id"
			if bonID == undefined then (
				bonID=FindID bon
			)
			if bonID == undefined then (
				txt = bon+" hasn't ID!"
				messagebox txt
			) else (
			bonID2 = bonID as string
			bon2 = sc3[i]
			format "\t\tBonePosition Float3 %\n\t\t{\n\t\t\tFramesData MultiChannel\n\t\t\t{\n\t\t\t\tchannel\n\t\t\t\t{\n" bonID2 to: o
			for i=0 to ar do (
				if bon2.parent!=undefined then (
					in coordsys parent (
						rx=at time i bon2.pos.x
						)
					) 
					else (
					rx=at time i bon2.pos.x
					)
				format "\t\t\t\t\t%\n" rx to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bon2.parent!=undefined then (
					in coordsys parent (
						ry=at time i bon2.pos.y
						)
					) 
					else (
					ry=at time i bon2.pos.y
					)
				format "\t\t\t\t\t%\n" ry to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bon2.parent!=undefined then (
					in coordsys parent (
						rz=at time i bon2.pos.z
						)
					) 
					else (
					rz=at time i bon2.pos.z
					)
				format "\t\t\t\t\t%\n" rz to: o
			)
			format "\t\t\t\t}\n\t\t\t}\n\t\t}\n" to: o
			format "\t\tBoneRotation Float4 %\n\t\t{\n\t\t\tFramesData MultiChannel\n\t\t\t{\n\t\t\t\tchannel\n\t\t\t\t{\n" bonID2 to: o
			for i=0 to ar do (
				if bon2.parent!=undefined then (
					in coordsys parent (
						rx=at time i bon2.rotation.x
						)
					) 
					else (
					rx=at time i bon2.rotation.x
					)
				format "\t\t\t\t\t%\n" rx to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bon2.parent!=undefined then (
					in coordsys parent (
						ry=at time i bon2.rotation.y
						)
					) 
					else (
					ry=at time i bon2.rotation.y
					)
				format "\t\t\t\t\t%\n" ry to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bon2.parent!=undefined then (
					in coordsys parent	(
						rz=at time i bon2.rotation.z
						)
					) else (
					rz=at time i bon2.rotation.z
					)
				format "\t\t\t\t\t%\n" rz to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bon2.parent!=undefined then (
					in coordsys parent (
						rw=at time i bon2.rotation.w
						)
					) else (
					rw=at time i bon2.rotation.w
					)
				format "\t\t\t\t\t%\n" rw to: o
			)
			format "\t\t\t\t}\n\t\t\t}\n\t\t}\n" to: o
			)
		)			
			format "\t}\n}\n" to: o
		)	
		else if (TypeExp.state==2) then (           --IN-GAME OBJECTS
			format "Version 8 2\n{\n\tFlags FLAG_0 FLAG_6 FLAG_7 FLAG_8\n" to: o
		format "\tFrames %\n" ar to: o
		format "\tSequenceFrameLimit %\n" ar to: o
		format "\tDuration %\n" ard to: o
		format "\t_f10 1520661046\n" to: o
		format "\tExtraFlags FLAG_1 FLAG_2\n" to: o
		format "\tSequences %\n" ar to: o
		format "\tMaterialID -1\n\tAnimation\n\t{\n" to: o
		Panims = ParList.items
		for i=1 to Panims.count do (
			bon = Panims[i]
			bon3 = sc3[i]
			bonID = getUserProp bon3 "id"
			if bonID == undefined then (
				bonID=FindID bon
			)
			if bonID == undefined then (
				txt = bon+" hasn't ID!"
				messagebox txt
			) else (
			bonID2 = bonID as string
			bon2 = sc3[i]
			format "\t\tBonePosition Float3 %\n\t\t{\n\t\t\tFramesData MultiChannel\n\t\t\t{\n\t\t\t\tchannel\n\t\t\t\t{\n" bonID2 to: o
			for i=0 to ar do (
				if bon2.parent!=undefined then (
					in coordsys parent (
						rx=at time i bon2.pos.x
						)
					) 
					else (
					rx=at time i bon2.pos.x
					)
				format "\t\t\t\t\t%\n" rx to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bon2.parent!=undefined then (
					in coordsys parent (
						ry=at time i bon2.pos.y
						)
					) 
					else (
					ry=at time i bon2.pos.y
					)
				format "\t\t\t\t\t%\n" ry to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bon2.parent!=undefined then (
					in coordsys parent (
						rz=at time i bon2.pos.z
						)
					) 
					else (
					rz=at time i bon2.pos.z
					)
				format "\t\t\t\t\t%\n" rz to: o
			)
			format "\t\t\t\t}\n\t\t\t}\n\t\t}\n" to: o
			format "\t\tBoneRotation Float4 %\n\t\t{\n\t\t\tFramesData MultiChannel\n\t\t\t{\n\t\t\t\tchannel\n\t\t\t\t{\n" bonID2 to: o
			for i=0 to ar do (
				if bon2.parent!=undefined then (
					in coordsys parent (
						rx=at time i bon2.rotation.x
						)
					) 
					else (
					rx=at time i bon2.rotation.x
					)
				format "\t\t\t\t\t%\n" rx to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bon2.parent!=undefined then (
					in coordsys parent (
						ry=at time i bon2.rotation.y
						)
					) 
					else (
					ry=at time i bon2.rotation.y
					)
				format "\t\t\t\t\t%\n" ry to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bon2.parent!=undefined then (
					in coordsys parent	(
						rz=at time i bon2.rotation.z
						)
					) else (
					rz=at time i bon2.rotation.z
					)
				format "\t\t\t\t\t%\n" rz to: o
			)
			format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
			for i=0 to ar do (
				if bon2.parent!=undefined then (
					in coordsys parent (
						rw=at time i bon2.rotation.w
						)
					) else (
					rw=at time i bon2.rotation.w
					)
				format "\t\t\t\t\t%\n" rw to: o
			)
			format "\t\t\t\t}\n\t\t\t}\n\t\t}\n" to: o
			)
		)			
			format "\t}\n}\n" to: o
		)	
		Nanims = animiv.mAnimList.items
		appendIfUnique Nanims ChaNam.text
	format "Version 1 2\n{\n" to: f
	for i=1 to Nanims.count do (
	fly = folna2+"\\"+Nanims[i]+".onim"
	format "\tcrAnimation %\n" fly to: f
	)
	format "}\n" to: f
	animiv.mAnimList.items = Nanims
	animiv.lbl2.text = "Total Animation: " + (Nanims.count as string) 
		close o
		close f
		) catch (
			local errmsg = getCurrentException()
			if o != undefined do (try(close o) catch())
			if f != undefined do (try(close f) catch())
			messageBox ("Export failed:\n" + errmsg)
		)
	)
	)
	)
)
)
)

rollout UVE "UV Animation"
(
	listBox UVmat selection:1 height:4
	button SelObj "Get Materials" width:120 align:#center
	editText UVNam "Anim. Name (without \"_uv_%\")" text:"" LabelOnTop:true align:#center width:150 height:18 offset:[0,5]
	button ExpUV "Export" width:100 align:#center tooltip:"Export model then export UV Animation"  Enabled:false
	
	fn DelComments s cs =
	(
	local ss = trimLeft s
	local p = FindString ss cs
	if p == undefined then return ss
	else
	if p > 1 then
	return substring ss 1 (p-1)
	else return ""
	)
	
	local uvs=#()
	local uvob=undefined
	
	on SelObj pressed do (
		if $selection.count==1 then (
			if (((classOf $) == Editable_mesh) or (classOf $) == Editable_poly) then (
				if $.material!=undefined then (
					if (classOf ($.material)==Multimaterial) then (
					for i=1 to $.material.count do (
						uvs[i]=$.material[i].name
					)
					UVmat.items=uvs
					uvob=$
					SelObj.text = ("\""+uvob.name+"\"")
					)
					else (
						uvs[1]=$.material.name
						UVmat.items=uvs
						uvob=$
						SelObj.text = ("\""+uvob.name+"\"")
					)
				)
				else (
				messagebox "Object hasn't materials"
				)
			)
			else (
				messagebox "Object should be an Editable Mesh or an Editable Poly"
			)
		)
		else (
			messagebox "Select one object!"
		)
	)
	
	 on ExpUV pressed do (									--UV EXPORT
	if (animiv.lbl1.text=="Anim. File:") then (
	messageBox "Create or load OAD-file"
	) else (	
	if (UVNam.text=="") then (
	messageBox "Enter name of UV animation"
	) else (
	uv=uvob
	if uv != undefined then (
		folna = getFilenamePath fname
		folna2 = DelComments (filenameFromPath fname) "."
		iduv=uvmat.selection-1
		opa = folna+folna2+ "\\" +uvNam.text+"_uv_"+(iduv as string)+".onim"
		ar = animationRange.end.frame as integer
		ard = (ar as float) / framerate
		makeDir (folna+folna2) all:false
		local o = undefined, f = undefined
		try (
		o = createfile opa
		local fResult = safeCreateFile fname
		if fResult == undefined then return()
		f = fResult[1]
		if fResult[2] != fname then messageBox ("Original OAD file was locked.\nWrote animation list to a copy instead:\n" + fResult[2] + "\n\nRestart 3ds Max, then rename this file over the original when you can.")
		format "Version 8 2\n{\n\tFlags FLAG_0 FLAG_6 FLAG_8\n" to: o
		format "\tFrames %\n" ar to: o
		format "\tSequenceFrameLimit %\n" ar to: o
		format "\tDuration %\n" ard to: o
		format "\t_f10 285410817\n\t_f28 0\n" to: o
		format "\tSequences %\n" ar to: o
		format "\tMaterialID %\n\tAnimation\n\t{\n" iduv to: o
		format "\t\tUV0 Float3 0\n\t\t{\n\t\t\tFramesData MultiChannel\n\t\t\t{\n\t\t\t\tchannel Static\n\t\t\t\t{\n\t\t\t\t\t1.00000000\n\t\t\t\t}\n\t\t\t\tchannel Static\n\t\t\t\t{\n\t\t\t\t\t0.00000000\n\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
		local uvli=#()
		for i=1 to meditmaterials.count do (
			uvli[i]=meditmaterials[i].name
		)
		if (classOf ($.material)==Multimaterial) then (
			uvab=finditem uvli (uv.material[uvmat.selection].name)
		)
		else (
			uvab=finditem uvli (uv.material.name)
		)
		for i=0 to ar do (
			uof=at time i meditmaterials[uvab][#maps][4].coords.u_offset
			format "\t\t\t\t\t%\n" uof to: o
		)
		format "\t\t\t\t}\n\t\t\t}\n\t\t}\n" to: o
		format "\t\tUV1 Float3 0\n\t\t{\n\t\t\tFramesData MultiChannel\n\t\t\t{\n\t\t\t\tchannel Static\n\t\t\t\t{\n\t\t\t\t\t0.00000000\n\t\t\t\t}\n\t\t\t\tchannel Static\n\t\t\t\t{\n\t\t\t\t\t1.00000000\n\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
		for i=0 to ar do (
			vof=at time i meditmaterials[uvab][#maps][4].coords.v_offset
			format "\t\t\t\t\t%\n" vof to: o
		)
		format "\t\t\t\t}\n\t\t\t}\n\t\t}\n\t}\n}\n" to: o
		Nanims = animiv.mAnimList.items
		appendIfUnique Nanims (uvNam.text+"_uv_"+(iduv as string))
	format "Version 1 2\n{\n" to: f
	for i=1 to Nanims.count do (
	fly = folna2+"\\"+Nanims[i]+".onim"
	format "\tcrAnimation %\n" fly to: f
	)
	format "}\n" to: f
	animiv.mAnimList.items = Nanims
	animiv.lbl2.text = "Total Animation: " + (Nanims.count as string)
		close o
		close f
		) catch (
			local errmsg = getCurrentException()
			if o != undefined do (try(close o) catch())
			if f != undefined do (try(close f) catch())
			messageBox ("Export failed:\n" + errmsg)
		)
	)
	else (
		messagebox "Select object!"
	)
)
)
)
)

rollout CamE "Camera Animation"
(
	editText CamNam "Anim. Name" text:"" LabelOnTop:true align:#center width:148 height:18 offset:[0,5]
		button ExpCam "Export" width:100 align:#center tooltip:"Export Camera Animation"  Enabled:false
	
	fn DelComments s cs =
	(
	local ss = trimLeft s
	local p = FindString ss cs
	if p == undefined then return ss
	else
	if p > 1 then
	return substring ss 1 (p-1)
	else return ""
	)
	
	 on ExpCam pressed do (									--CAMERA EXPORT
	if (animiv.lbl1.text=="Anim. File:") then (
	messageBox "Create or load OAD-file"
	) else (	
	if (CamNam.text=="") then (
	messageBox "Enter name of camera animation"
	) else (
	local cam = undefined
    for obj in selection do (
		if ((classOf obj) == Freecamera) then 
		(
	 	  if obj != undefined then cam = obj	
		) 
	)	
	clearSelection()
   if cam != undefined then Select cam	
     else messageBox "Camera is not selected"
 if selection.count > 0 then ( 
	if cam != undefined then (
		folna = getFilenamePath fname
		folna2 = DelComments (filenameFromPath fname) "."
		opa = folna+folna2+ "\\" +CamNam.text+".onim"
		ar = animationRange.end.frame as integer
		ard = (ar as float) / framerate
		makeDir (folna+folna2) all:false
		local o = undefined, f = undefined
		try (
		o = createfile opa
		local fResult = safeCreateFile fname
		if fResult == undefined then return()
		f = fResult[1]
		if fResult[2] != fname then messageBox ("Original OAD file was locked.\nWrote animation list to a copy instead:\n" + fResult[2] + "\n\nRestart 3ds Max, then rename this file over the original when you can.")
		format "Version 8 2\n{\n\tFlags FLAG_0 FLAG_7 FLAG_8\n" to: o
		format "\tFrames %\n" ar to: o
		format "\tSequenceFrameLimit %\n" ar to: o
		format "\tDuration %\n" ard to: o
		format "\t_f10 1999715593\n\t_f28 0\n" to: o
		format "\tSequences %\n" ar to: o
		format "\tMaterialID -1\n\tAnimation\n\t{\n\t\tCameraPosition Float3 0\n\t\t{\n\t\t\tFramesData MultiChannel\n\t\t\t{\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
		pov = eulertoquat (eulerAngles 90 0 0)
		for i=0 to ar do (
			px=at time i cam.pos.x
			format "\t\t\t\t\t%\n" px to: o
		)
		format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
		for i=0 to ar do (
			py=at time i cam.pos.y
			format "\t\t\t\t\t%\n" py to: o
		)
		format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
		for i=0 to ar do (
			pz=at time i cam.pos.z
			format "\t\t\t\t\t%\n" pz to: o
		)
		format "\t\t\t\t}\n\t\t\t}\n\t\t}\n\t\tCameraRotation Float4 0\n\t\t{\n\t\t\tFramesData MultiChannel\n\t\t\t{\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
		for i=0 to ar do (
					full1 = ((at time i cam.rotation) * pov)
					rx=full1.x
			format "\t\t\t\t\t%\n" rx to: o
		)
		format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
		for i=0 to ar do (
					full2 = ((at time i cam.rotation) * pov)
					ry=full2.y
			format "\t\t\t\t\t%\n" ry to: o
		)
		format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
		for i=0 to ar do (
					full3 = ((at time i cam.rotation) * pov)
					rz=full3.z
			format "\t\t\t\t\t%\n" rz to: o
		)
		format "\t\t\t\t}\n\t\t\t\tchannel\n\t\t\t\t{\n" to: o
		for i=0 to ar do (
					full4 = ((at time i cam.rotation) * pov)
					rw=full4.w
			format "\t\t\t\t\t%\n" rw to: o
		)
		format "\t\t\t\t}\n\t\t\t}\n\t\t}\n\t\tCameraFOV Float 0\n\t\t{\n\t\t\tFramesData SingleChannel\n\t\t\t{\n" to: o
		for i=0 to ar do (
			fov1=at time i cam.fov
			format "\t\t\t\t%\n" fov1 to: o
		)
		format "\t\t\t}\n\t\t}\n\t\tCameraDof Float3 0\n\t\t{\n\t\t\tFramesData SingleChannel Static\n\t\t\t{\n\t\t\t\t1.00000000 -1600.00000000 0.00000000\n\t\t\t}\n\t\t}\n\t\tCameraMatrixRotateFactor Float 0\n\t\t{\n\t\t\tFramesData SingleChannel Static\n\t\t\t{\n\t\t\t\t0.00000000\n\t\t\t}\n\t\t}\n\t\tCameraControl Float 0\n\t\t{\n\t\t\tFramesData SingleChannel\n\t\t\t{\n" to: o
		for i=0 to ar do (
			format "\t\t\t\t-1.00000000\n" to: o
		)
		format "\t\t\t}\n\t\t}\n\t}\n}\n" to: o
		Nanims = animiv.mAnimList.items
		appendIfUnique Nanims CamNam.text
	format "Version 1 2\n{\n" to: f
	for i=1 to Nanims.count do (
	fly = folna2+"\\"+Nanims[i]+".onim"
	format "\tcrAnimation %\n" fly to: f
	)
	format "}\n" to: f
	animiv.mAnimList.items = Nanims
	animiv.lbl2.text = "Total Animation: " + (Nanims.count as string)
		close o
		close f
		) catch (
			local errmsg = getCurrentException()
			if o != undefined do (try(close o) catch())
			if f != undefined do (try(close f) catch())
			messageBox ("Export failed:\n" + errmsg)
		)
	)
	)
)
)
)
)

rollout author "About" (
	label n1 "OAD Exporter 1.0"
	label n3 "by Andr\xe6s"
	label n4 "http://vk.com/petrov_and"
	label n5 " "
	label n6 "Thanks to:"
	label n7 "Alexander Blade, GooD-NTS,"
	label n8 "3Doomer, Blaster_nl"
	label n9 " "
	label n0 "June 30, 2013"
)

if oadexp != undefined then (
	closeRolloutFloater oadexp
	gc()
)
oadexp = newRolloutFloater "Andrew's OAD Exporter" 185 660 20 20
addRollout AnimIV oadexp
addrollout CharE oadexp 
addrollout ObjE oadexp
addrollout UVE oadexp rolledup:true
addrollout CamE oadexp rolledup:true
addRollout author oadexp rolledup:true
