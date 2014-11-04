clear
clc

subListFile='/home/data/Projects/Zhen/hematocrit/data/Rockland/subList_ultraclearn50sub_poster.txt';
subList1=fopen(subListFile);
subList=textscan(subList1, '%s', 'delimiter', '\n')
subList=cell2mat(subList{1});
m=0;
n=0;
q=0;
for i=1:length(subList)
    sub=char(subList(i, 1:9));
    disp (['Working on sub ', sub])
    
    mkdir (['/home/data/Projects/Zhen/hematocrit/data/Rockland/', sub, '/rest'])
    mkdir (['/home/data/Projects/Zhen/hematocrit/data/Rockland/', sub, '/anat'])
    funImgDir=['/home/data/Projects/Zhen/hematocrit/data/Rockland/', sub, '/rest'];
    T1ImgDir=['/home/data/Projects/Zhen/hematocrit/data/Rockland/', sub, '/anat'];
    
    if strcmp(sub, 'M10905290')
        funImg=['/home/data/Incoming/DiscSci/NIFTI/BOLD/', char(sub), '_RFA/REST_645.nii.gz'];
        T1Img=['/home/data/Incoming/DiscSci/NIFTI/T1/', char(sub), '_RFA/anat.nii.gz'];
        copyfile(funImg, [funImgDir, '/rest.nii.gz'])
        copyfile(T1Img, [T1ImgDir, '/anat.nii.gz'])
        
    elseif strcmp(sub, 'M10993358')
        funImg=['/home/data/Incoming/DiscSci/NIFTI/BOLD/', char(sub), '_JAF/REST_645.nii.gz'];
        T1Img=['/home/data/Incoming/DiscSci/NIFTI/T1/', char(sub), '_JAF/anat.nii.gz'];
        copyfile(funImg, [funImgDir, '/rest.nii.gz'])
        copyfile(T1Img, [T1ImgDir, '/anat.nii.gz'])
        
    else
        
        file1=['/home/data/Incoming/DiscSci/NIFTI/BOLD/', char(sub), '/REST_645.nii.gz'];
        file2=['/home/data/Incoming/DiscSciR4/mmilham/NIFTI/', char(sub), '/Study30-001/REST_645.nii.gz'];
        file3=['/home/data/Incoming/DiscSci_R5/NIFTI/BOLD/', char(sub), '_Ds2/REST_645.nii.gz'];
        file4=['/home/data/Incoming/DiscSci_R5/NIFTI/BOLD/', char(sub), '/REST_645.nii.gz'];
        
        if exist(file1, 'file')
            T1Img=['/home/data/Incoming/DiscSci/NIFTI/T1/', char(sub), '/anat.nii.gz'];
            
            copyfile(file1, [funImgDir, '/rest.nii.gz'])
            copyfile(T1Img, [T1ImgDir, '/anat.nii.gz'])
        elseif exist(file2, 'file')
            T1Img=['/home/data/Incoming/DiscSciR4/mmilham/NIFTI/', char(sub), '/Study30-001/anat.nii.gz'];
            copyfile(file2, [funImgDir, '/rest.nii.gz'])
            copyfile(T1Img, [T1ImgDir, '/anat.nii.gz'])
        elseif exist(file3, 'file')
            T1Img=['/home/data/Incoming/DiscSci_R5/NIFTI/T1/', char(sub), '_Ds2/anat.nii.gz'];
            copyfile(file3, [funImgDir, '/rest.nii.gz'])
            copyfile(T1Img, [T1ImgDir, '/anat.nii.gz'])
m=m+1;
        elseif exist(file4, 'file')
            T1Img=['/home/data/Incoming/DiscSci_R5/NIFTI/T1/', char(sub), '/anat.nii.gz'];
            copyfile(file4, [funImgDir, '/rest.nii.gz'])
            copyfile(T1Img, [T1ImgDir, '/anat.nii.gz'])
n=n+1;
        else
            q=q+1;
            subMissing(q,:)=sub;
        end
    end
end
q
subMissing
disp ([num2str(m+n), ' subjects are fro DiscSci_R5.'])


