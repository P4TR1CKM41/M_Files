function Y = correctumlaut(string)
for i = 1:length(string)
    if string(i) == '�'
        string(i) = 'a';
    elseif string(i) == '-'
        string(i) = '_';
    elseif string(i) == '�'
        string(i) = 'o';
    elseif string(i) == '�'
        string(i) = 'u';
    elseif string(i) == '�'
        string(i) = 's';
    end
end

Y = string;