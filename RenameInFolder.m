target=4;

A=dir([pwd filesep '*_' num2str(target) '.*']);
for iFile=1:length(A)
    oldName=A(iFile).name;
    pos = strfind(oldName,['_' num2str(target)]);
    newName = oldName;
    newName(pos:pos+length(num2str(target)))=[];
    disp(['Renaming "' oldName '" >>> " to "' newName '"']) 
    movefile(oldName,newName)
end
