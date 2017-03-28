```
public static int search(int[] arr, int searchValue) {
		int left = 0;
		int right = arr.length - 1;
		return binarySearch(arr, searchValue, left, right);
	}

private static int binarySearch(int[] arr, int searchValue, int left, int right) {
	if (right < left) {
		return NOT_FOUND;
	}
	/*
	int mid = mid = (left + right) / 2;
	There is a bug in the above line;
	Joshua Bloch suggests the following replacement:
	*/
	int mid = (left + right) >>> 1;
	if (searchValue > arr[mid]) {
		return binarySearch(arr, searchValue, mid + 1, right);
	} else if (searchValue < arr[mid]) {
		return binarySearch(arr, searchValue, left, mid - 1);
	} else {
		return mid;
	}
}
```
--------------------------------------------------------------------------------------
```
//冒泡排序
public void bubbleSort(int[] arr){
	for(int i=0;i<arr.length-1;i++){
		for(int j=arr.length-1;j>i;j--){
			if(arr[j]<arr[j-1]){
				int tmp=arr[j];
				arr[j]=arr[j-1];
				arr[j-1]=tmp;
			}
		}
	}
}
//冒泡排序的改良版
public void bubbleSort_plus(int[] arr){
	boolean flag=true;
	for(int i=0;i<arr.length-1&&flag;i++){
		flag=false;
		for(int j=arr.length-1;j>i;j--){
			if(arr[j]<arr[j-1]){
				flag=true;
				int tmp=arr[j];
				arr[j]=arr[j-1];
				arr[j-1]=tmp;
			}
		}
	}
}
```
--------------------------------------------------------------------------------------