import React from 'react';
import Draggable from '../../lib/draggable';
import tasks from '../tasks';
import getSubjectLocation from '../../lib/get-subject-location';
import SVGImage from '../../components/svg-image';

export default class ImageAnnotator extends React.Component {
  constructor(props) {
    super(props);
    this.getScreenCurrentTransformationMatrix = this.getScreenCurrentTransformationMatrix.bind(this);
    this.getEventOffset = this.getEventOffset.bind(this);
    this.normalizeDifference = this.normalizeDifference.bind(this);
    this.eventCoordsToSVGCoords = this.eventCoordsToSVGCoords.bind(this);
  }

  getSizeRect() {
    const clientRect = this.sizeRect && this.sizeRect.getBoundingClientRect();

    if (clientRect) {
      const { width, height } = clientRect;
      let { left, right, top, bottom } = clientRect;
      left += pageXOffset;
      right += pageXOffset;
      top += pageYOffset;
      bottom += pageYOffset;
      return { left, right, top, bottom, width, height };
    }
    return { left: 0, right: 0, top: 0, bottom: 0, width: 0, height: 0 };
  }

  getScale() {
    const sizeRect = this.getSizeRect();
    const horizontal = sizeRect ? sizeRect.width / this.props.naturalWidth : 0;
    const vertical = sizeRect ? sizeRect.height / this.props.naturalHeight : 0;

    return { horizontal, vertical };
  }

  // get current transformation matrix
  getScreenCurrentTransformationMatrix() {
    const svg = this.refs.svgSubjectArea;
    return svg.getScreenCTM();
  }

  // find the original matrix for the SVG coordinate system
  getMatrixForWindowCoordsToSVGUserSpaceCoords() {
    const transformationContainer = this.refs.transformationContainer;
    return transformationContainer.getScreenCTM().inverse();
  }

  // get the offset of event coordiantes in terms of the SVG coordinate system
  getEventOffset(e) {
    return this.eventCoordsToSVGCoords(e.clientX, e.clientY);
  }

  // transforms the difference between two event coordinates
  // into the difference as represent in the SVG coordinate system
  normalizeDifference(e, d) {
    const difference = {};
    const normalizedPoint1 = this.eventCoordsToSVGCoords(e.pageX - d.x, e.pageY - d.y);
    const normalizedPoint2 = this.eventCoordsToSVGCoords(e.pageX, e.pageY);
    difference.x = normalizedPoint2.x - normalizedPoint1.x;
    difference.y = normalizedPoint2.y - normalizedPoint1.y;
    return difference;
  }

  // transforms the event coordinates
  // to points in the SVG coordinate system
  eventCoordsToSVGCoords(x, y) {
    const svg = this.refs.svgSubjectArea;
    const newPoint = svg.createSVGPoint();
    newPoint.x = x;
    newPoint.y = y;
    const matrixForWindowCoordsToSVGUserSpaceCoords = this.getMatrixForWindowCoordsToSVGUserSpaceCoords();
    const pointforSVGSystem = newPoint.matrixTransform(matrixForWindowCoordsToSVGUserSpaceCoords);
    return pointforSVGSystem;
  }

  render() {
    let taskDescription;
    let TaskComponent;
    const { type, src } = getSubjectLocation(this.props.subject, this.props.frame);
    const createdViewBox = `${this.props.viewBoxDimensions.x} ${this.props.viewBoxDimensions.y} ${this.props.viewBoxDimensions.width} ${this.props.viewBoxDimensions.height}`;

    if (this.props.annotation) {
      taskDescription = this.props.workflow.tasks[this.props.annotation.task];
      TaskComponent = tasks[taskDescription.type];
    }

    const svgStyle = {};
    if (type === 'image' && !this.props.loading) {
      // Images are rendered again within the SVG itself.
      // When cropped right next to the edge of the image,
      // the original tag can show through, so fill the SVG to cover it.
      svgStyle.background = 'black';

      // Allow touch scrolling on subject for mobile and tablets
      if (taskDescription) {
        if ((taskDescription.type !== 'drawing') && (taskDescription.type !== 'crop')) {
          svgStyle.pointerEvents = 'none';
        }
      }
      if (this.props.panEnabled === true) {
        svgStyle.pointerEvents = 'all';
      }
    }

    const svgProps = {};

    const hookProps = {
      taskTypes: tasks,
      workflow: this.props.workflow,
      task: taskDescription,
      classification: this.props.classification,
      annotation: this.props.annotation,
      frame: this.props.frame,
      scale: this.getScale(),
      naturalWidth: this.props.naturalWidth,
      naturalHeight: this.props.naturalHeight,
      containerRect: this.getSizeRect(),
      getEventOffset: this.getEventOffset,
      onChange: this.props.onChange,
      preferences: this.props.preferences,
      normalizeDifference: this.normalizeDifference,
      getScreenCurrentTransformationMatrix: this.getScreenCurrentTransformationMatrix
    };

    Object.keys(tasks).map((task) => {
      const Component = tasks[task];
      if (Component.getSVGProps) {
        Object.assign(svgProps, Component.getSVGProps(hookProps));
      }
    });

    const children = React.Children.map(this.props.children, (child) => {
      return React.cloneElement(child, hookProps);
    });

    return (
      <svg
        ref="svgSubjectArea"
        className="subject"
        style={svgStyle}
        viewBox={createdViewBox}
        {...svgProps}
      >
        <g
          ref="transformationContainer"
          transform={this.props.transform}
        >
          <rect
            ref={(rect) => { this.sizeRect = rect; }}
            width={this.props.naturalWidth}
            height={this.props.naturalHeight}
            fill="rgba(0, 0, 0, 0.01)"
            fillOpacity="0.01"
            stroke="none"
          />
          {type === 'image' && (
            <Draggable onDrag={this.props.panByDrag} disabled={this.props.disabled}>
              <SVGImage
                className={this.props.panEnabled ? 'pan-active' : ''}
                src={src}
                width={this.props.naturalWidth}
                height={this.props.naturalHeight}
                modification={this.props.modification}
              />
            </Draggable>
          )}

          {children}

        </g>
      </svg>
    );
  }
}

ImageAnnotator.propTypes = {
  annotation: React.PropTypes.shape({
    task: React.PropTypes.string
  }),
  children: React.PropTypes.node,
  classification: React.PropTypes.shape({
    annotations: React.PropTypes.array,
    loading: React.PropTypes.bool
  }),
  disabled: React.PropTypes.bool,
  frame: React.PropTypes.number,
  loading: React.PropTypes.bool,
  modification: React.PropTypes.object,
  naturalHeight: React.PropTypes.number,
  naturalWidth: React.PropTypes.number,
  onChange: React.PropTypes.func,
  panByDrag: React.PropTypes.func,
  panEnabled: React.PropTypes.bool,
  preferences: React.PropTypes.object,
  subject: React.PropTypes.shape({
    already_seen: React.PropTypes.bool,
    retired: React.PropTypes.bool
  }),
  transform: React.PropTypes.string,
  viewBoxDimensions: React.PropTypes.shape({
    height: React.PropTypes.number,
    width: React.PropTypes.number,
    x: React.PropTypes.number,
    y: React.PropTypes.number
  }),
  workflow: React.PropTypes.shape({
    tasks: React.PropTypes.object
  })
};

ImageAnnotator.defaultProps = {
  user: null,
  project: null,
  subject: null,
  workflow: null,
  classification: null,
  annotation: null,
  onLoad: () => {},
  frame: 0,
  onChange: () => {}
};
