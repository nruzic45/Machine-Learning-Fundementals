function odluka = cifer_recognition(x,fs)

    % jedan = zeros(10,3);
    jedan=[];
    for i=1:10
        [test, fs] = audioread('1.' + string(i) + '.wav');
        y = preprocessing(test,fs);
        klasa = feature_extraction(y,fs);
        jedan = [jedan; klasa];
    end

    % dva = zeros(10,3);
    dva = [];
    for i=1:10
        [test, fs] = audioread('2.' + string(i) + '.wav');
        y = preprocessing(test,fs);
        klasa = feature_extraction(y,fs);
        dva = [dva; klasa];
    end

    % tri = zeros(10,3);
    tri=[];
    for i=1:10
        [test, fs] = audioread('3.' + string(i) + '.wav');
        y = preprocessing(test,fs);
        klasa = feature_extraction(y,fs);
        tri = [tri; klasa];
    end
    
    jedan = [jedan, ones(10,1)];
    dva = [dva, ones(10,1)*2];
    tri = [tri, ones(10,1)*3];

    train = [jedan; dva; tri];
    
    X = train(:,1:2);
    Y = train(:,3);

    % Koristimo k=3, za knn, jer srt(10) ~ 3
    mdl = fitcknn(X,Y,'NumNeighbors',3,'Standardize',1);


    % Prediction

   
    y = preprocessing(x,fs);
    Xnew = feature_extraction(y,fs);

    [label,score,cost] = predict(mdl,Xnew);
    odluka = label;

end