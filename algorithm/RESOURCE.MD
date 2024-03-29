二分查找法
```java
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
冒泡排序
```java
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

[最小栈的实现](https://juejin.im/post/5a2ff8c651882533d0230a85)
[漫画：什么是动态规划？](https://juejin.im/post/5a29d52cf265da43333e4da7)
[漫画算法：找出缺失的整数](https://juejin.im/post/5a366ea1f265da431a4345af)
[漫画算法：辗转相除法是什么鬼？](https://juejin.im/post/5a217bac51882531926e8656)
[你需要知道的算法之基础篇:时间复杂度](https://juejin.im/post/5a3603d2f265da4321541e95)