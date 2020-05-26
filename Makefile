clone:
	git clone git@github.com:onai/detectron2.git

make_dir:
	mkdir inputs && chmod -R 777 inputs && mkdir outputs && chmod -R 777 outputs && mkdir models && chmod -R 777 models 

build_image: detectron2 inputs outputs models
	cd detectron2/docker && docker build -t detectron2:v0 .

input_image: inputs
	cp ${img} inputs

run: inputs outputs
	docker run --rm --gpus all -it -v $(abspath outputs):/home/appuser/detectron2_repo/outputs:rw -v $(abspath inputs):/home/appuser/detectron2_repo/inputs:rw -v $(abspath models):/tmp:rw  --name=detectron2 detectron2:v0 python demo/demo.py --config-file configs/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml --input inputs/${img} --output outputs/ --opts MODEL.WEIGHTS detectron2://COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x/137849600/model_final_f10217.pkl

interactive: detectron2
	docker run --rm --gpus all -it -v $(abspath outputs):/home/appuser/detectron2_repo/outputs:rw -v $(abspath inputs):/home/appuser/detectron2_repo/inputs:rw -v $(abspath models):/tmp:rw --name=detectron2 detectron2:v0

clean: detectron2 inputs outputs models
	rm -rf detectron2 && rm -rf inputs && rm -rf outputs && rm -rf models
