function mse = f(theta,x,y)

y_fit=logistic_A_x0_lambda_baseline(theta,x);
res=y_fit-y;
mse=sum(res.^2);
