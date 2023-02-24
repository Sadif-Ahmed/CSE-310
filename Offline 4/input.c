//int x[10];
int main(){
 
	int i, x[10];	
	x[0]=-2;
	x[1]=x[0];
	i=x[0];	
	println(i);
	x[1]=x[0]++;
	i=x[1];	
	println(i);
	i=x[0];
	println(i);	
	
	i=i+0;
	i=i-0;
	i=i*1;
	println(i);	
	
	if((i>0 && i<10) || (i<0 && i>-10))
		i=100;
	else 
		i=200;
	println(i);	
	
	return 0;
}
