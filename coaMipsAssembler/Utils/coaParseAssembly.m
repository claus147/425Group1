function list = coaParseAssembly(filename)

    fid = fopen(filename);
    
    tline = fgetl(fid);
    
    t_list = {};
    list = {};
    functs = {'addi','add','sub','div','mult','slti','slt','andi', ...
        'and','ori','or','xori','xor','nor','mfhi','mflo','lui', ...
        'sll','slr','sra','lw','lb','sw','sb','beq','bne','jr','jal','j'};
    
    types = {'I','R','R','R','R','I','R','I', ...
        'R','I','R','I','R','R','R','R','I', ...
        'R','R','R','I','I','I','I','I','I','R','J','J'};
    
    while ischar(tline)
        
        tmp = textscan(tline,'%c');
        line_str = tmp{1}';
        if isempty(line_str)
        
            % Do nothing
            
        elseif line_str(1) ~= '#'
            
            idx = strfind(line_str,'#');
            
            if ~isempty(idx)
                
                line_str(idx(1):end) = [];
                
            end
            
            idx = strfind(line_str,':');
            
            if ~isempty(idx)
                
                label = line_str(1:idx(1));
                t_list = cat(1,t_list, {label,'label','','','',''});
                
                line_str(1:idx(1)) = [];
                
            end
                
            if ~isempty(line_str)
                
                n = 1;
                
                idx = strfind(line_str,functs{n});
                
                while isempty(idx)
                    
                    n = n+1;
                    idx = strfind(line_str,functs{n});
                    
                end
                
                line_str = strrep(line_str,functs{n},'');
                
                line_args = strsplit(line_str,',');
                
                num_args = length(line_args);
                
                switch num_args
                    
                    case 3
                        
                        tmp = cat(2,line_str,functs{n},types{n},line_args);
                        
                    case 2
                        
                        % Check for 0($d)
                        orig = line_args{2};
                        expr = '\d*\(';
                        
                        check = regexp(orig,expr,'match');
                        
                        if isempty(check)
                        
                            tmp = cat(2,line_str,functs{n},types{n},line_args,' ');
                            
                        else
                            
                            expr = '\d*';
                            immed = regexp(check{1},expr,'match');
                            
                            expr = '\$\d*';
                            reg = regexp(orig,expr,'match');
                            
                            line_args{2} = reg{1};
                            
                            tmp = cat(2,line_str,functs{n},types{n},line_args,immed{1});
                            
                        end
                        
                    case 1
                        
                        tmp = cat(2,line_str,functs{n},types{n},line_args,' ',' ');
                        
                    case 0
                        
                        tmp = cat(2,line_str,functs{n},types{n},' ',' ',' ');
                    
                end
                    
                
                t_list = cat(1,t_list, tmp);
            end
            
        end
        tline = fgetl(fid);
        
    end
    
    [count,~] = size(t_list);
    
    %num_labels = sum(strcmp('label',list(:,2)));
    
    %list = cell(count-num_labels,6);
    
    n = 1;
    
    while n <= count
        
        if strcmp(t_list{n,2},'label')
            
            list = cat(1,list,{t_list{n+1,:}, t_list{n,1}(1:end-1)});
            n = n+1;
            
        else
            
            list = cat(1,list,{t_list{n,:}, ''});
            
        end
        
        n = n+1;
        
    end
    
    
    label_idxs = find(~strcmp(list(:,7),''));
    labels = list(label_idxs,7);
    
    for m = 1:length(labels)
        
        for n = 4:6
            label = labels{m};
            label_idx = label_idxs(m);
            
            hits = find(strcmp(list(:,n),label));
            
            for o = 1:length(hits)
                
                list{hits(o),n} = num2str(label_idx - (hits(o)+1));
                
            end
            
        end
        
        
    end
    
    list(:,1) = [];
    
    fclose(fid);
    
end