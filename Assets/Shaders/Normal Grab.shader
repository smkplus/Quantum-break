// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/DistortingGrabPass" {
	Properties{
		_Intensity("Intensity",Float) = 0
	}
		SubShader{
		GrabPass{ "_GrabTexture" }

		Pass{
		ZTEST ALways
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "PreviewType" = "Plane" }
		Tags{ "LightMode" = "Vertex" }

		Lighting On
		ColorMaterial AmbientAndDiffuse
		Blend SrcAlpha OneMinusSrcAlpha

		ZWrite Off
		ColorMask RGB

		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

		struct v2f {
		half4 pos : SV_POSITION;
		half4 grabPos : TEXCOORD0;
		half3 worldNormal : TEXCOORD1;

	};

	sampler2D _GrabTexture;
	half _Intensity;

	v2f vert(appdata_full v) {
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.grabPos = ComputeGrabScreenPos(o.pos);
		o.worldNormal = UnityObjectToWorldNormal(v.normal);

		return o;
	}

	half4 frag(v2f i) : COLOR{
		fixed4 c = 0;
		c.rgb = i.worldNormal*0.5 + 0.5;
	//i.grabPos.x +=  _Intensity;
	fixed4 color = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.grabPos));
	return color;
	}
		ENDCG
	}
	}
		FallBack "Diffuse"
}