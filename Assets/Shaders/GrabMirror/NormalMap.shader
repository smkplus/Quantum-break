Shader "Custom/GrabPassInvertColors"
{
    SubShader
    {
        Tags { "Queue" = "Transparent" }
 
        GrabPass
        {
            "_GrabTexture"
        }
 
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
 
            #include "UnityCG.cginc"
 
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float3 normal :NORMAL;
            };
 
            struct v2f
            {
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				half3 worldNormal :TEXCOORD1;

            };
 
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = ComputeGrabScreenPos(o.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }
 
            sampler2D _GrabTexture;
 
            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 c = 0;
				c.rgb = i.worldNormal*0.5+0.5;
                fixed4 col = tex2Dproj(_GrabTexture, i.uv);
                return c;
            }
            ENDCG
        }
    }
}